// App state provider

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/trip.dart';
import '../models/settings.dart';
import '../models/car.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/offline_queue.dart';
import '../services/carplay_service.dart';
import '../services/bluetooth_service.dart';
import '../services/background_service.dart';
import '../services/auth_service.dart';

// Callback for unknown device - used to trigger car linking flow
typedef UnknownDeviceCallback = void Function(String deviceName);

class AppProvider extends ChangeNotifier {
  static const String _settingsKey = 'app_settings';

  // Services
  late ApiService _api;
  late LocationService _location;
  late OfflineQueue _offlineQueue;
  late CarPlayService _carPlay;
  late BluetoothService _bluetooth;
  late BackgroundService _background;

  // State
  AppSettings _settings = AppSettings.defaults();
  ActiveTrip? _activeTrip;
  List<Trip> _trips = [];
  Stats? _stats;
  CarData? _carData;
  bool _isLoading = false;
  String? _error;
  int _queueLength = 0;
  bool _isOnline = true;
  bool _isCarPlayConnected = false;
  bool _isBluetoothConnected = false;
  String? _connectedBluetoothDevice;
  String? _pendingUnknownDevice; // Device waiting to be linked to a car

  // Loading states for each section (start true so spinners show on boot)
  bool _isLoadingCars = true;
  bool _isLoadingCarData = true;
  bool _isLoadingStats = true;
  bool _isLoadingTrips = true;

  // Multi-car state
  List<Car> _cars = [];
  Car? _selectedCar; // Selected car (required, auto-selects default)
  String? _selectedCarId; // For filtering

  // Navigation state
  int _navigationIndex = 0;

  // Callback for unknown device
  UnknownDeviceCallback? onUnknownDevice;

  // Getters
  AppSettings get settings => _settings;
  bool get isConfigured => _settings.isConfigured;
  ActiveTrip? get activeTrip => _activeTrip;
  List<Trip> get trips => _trips;
  Stats? get stats => _stats;
  CarData? get carData => _carData;
  bool get isLoading => _isLoading;
  bool get isLoadingCars => _isLoadingCars;
  bool get isLoadingCarData => _isLoadingCarData;
  bool get isLoadingStats => _isLoadingStats;
  bool get isLoadingTrips => _isLoadingTrips;
  String? get error => _error;
  int get queueLength => _queueLength;
  bool get isOnline => _isOnline;
  bool get isCarPlayConnected => _isCarPlayConnected;
  bool get isBluetoothConnected => _isBluetoothConnected;
  String? get connectedBluetoothDevice => _connectedBluetoothDevice;
  String? get pendingUnknownDevice => _pendingUnknownDevice;
  bool get isTrackingLocation => _location.isTracking;

  // Multi-car getters
  List<Car> get cars => _cars;
  Car? get selectedCar => _selectedCar;
  String? get selectedCarId => _selectedCarId;
  Car? get defaultCar => _cars.isEmpty ? null : _cars.firstWhere((c) => c.isDefault, orElse: () => _cars.first);

  // Navigation getter
  int get navigationIndex => _navigationIndex;

  // Navigate to a specific tab
  void navigateTo(int index) {
    _navigationIndex = index;
    notifyListeners();
  }

  AppProvider() {
    _api = ApiService(
      baseUrl: _settings.apiUrl,
      userEmail: _settings.userEmail,
    );
    _location = LocationService();
    _offlineQueue = OfflineQueue(_api);
    _carPlay = CarPlayService();
    _bluetooth = BluetoothService();
    _background = BackgroundService();
    // Fire and forget - don't block constructor
    Future.microtask(() => _init());
  }

  Future<void> _init() async {
    // Load settings (local, should be fast)
    await _loadSettings();

    // Setup listeners
    _listenToConnectivity();
    _setupCarPlayListener();
    _setupBluetoothListener();
    _setupBackgroundListener();
    _checkConnectivity();

    // Wait for auth to initialize before loading data
    await AuthService().init();

    // Load data in background
    if (isConfigured) {
      refreshAll();
      // Resume tracking if there was an active trip
      _checkAndResumeTracking();
    }
  }

  Future<void> _checkAndResumeTracking() async {
    try {
      await refreshActiveTrip();
      if (_activeTrip?.active == true && !_location.isTracking) {
        print('[Background] Active trip detected on startup, resuming tracking');
        _startBackgroundTracking();
      }
    } catch (e) {
      print('[Background] Error checking active trip: $e');
    }
  }

  void _setupCarPlayListener() {
    // Check initial CarPlay status
    _carPlay.checkConnection().then((connected) {
      _isCarPlayConnected = connected;
      notifyListeners();
    });

    // Listen for CarPlay connection changes
    _carPlay.setConnectionCallback((connected) {
      _isCarPlayConnected = connected;
      notifyListeners();

      if (connected) {
        print('[CarPlay] Connected - checking for auto-start...');
        _tryAutoStartTrip();
      } else {
        // When CarPlay disconnects, keep tracking - backend will end trip
        print('[CarPlay] Disconnected - keeping trip active, backend will end when parked');
      }
    });
  }

  void _setupBluetoothListener() {
    // Check initial Bluetooth status
    _bluetooth.getConnectedDevice().then((deviceName) {
      _connectedBluetoothDevice = deviceName;
      _isBluetoothConnected = deviceName != null;
      notifyListeners();
    });

    // Listen for Bluetooth connection changes
    _bluetooth.setConnectionCallback((deviceName) {
      _connectedBluetoothDevice = deviceName;
      _isBluetoothConnected = deviceName != null;
      notifyListeners();

      if (deviceName != null) {
        print('[Bluetooth] Connected: $deviceName - checking for auto-start...');
        _tryAutoStartTrip();
      } else {
        print('[Bluetooth] Disconnected - keeping trip active');
      }
    });
  }

  void _setupBackgroundListener() {
    // Start background monitoring for car detection (survives force-quit)
    _background.startMonitoring();

    // Listen for car detection events from background
    _background.setCarDetectedCallback((deviceName, lat, lng) async {
      print('[Background] Car detected callback: $deviceName at $lat, $lng');

      // Update state
      _connectedBluetoothDevice = deviceName;
      _isBluetoothConnected = true;
      notifyListeners();

      // Try to auto-start trip
      if (!_settings.autoDetectCar || !isConfigured) {
        print('[Background] Auto-detect disabled or not configured');
        return;
      }

      if (_activeTrip?.active == true) {
        print('[Background] Trip already active');
        return;
      }

      // Find matching car
      final car = findCarByDeviceId(deviceName);
      if (car != null) {
        print('[Background] Found car: ${car.name} - starting trip');
        await startTripForCar(car, deviceName);
      } else {
        print('[Background] Unknown device: $deviceName');
        _pendingUnknownDevice = deviceName;
        notifyListeners();
        onUnknownDevice?.call(deviceName);
      }
    });

  }

  /// Find car by its carplay_device_id
  Car? findCarByDeviceId(String deviceId) {
    try {
      return _cars.firstWhere(
        (car) => car.carplayDeviceId != null &&
                 car.carplayDeviceId!.toLowerCase() == deviceId.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Try to auto-start trip when CarPlay or Bluetooth connects
  Future<void> _tryAutoStartTrip() async {
    if (!_settings.autoDetectCar || !isConfigured) {
      print('[AutoStart] Disabled or not configured');
      return;
    }

    // Already have an active trip? Don't start another
    if (_activeTrip?.active == true) {
      print('[AutoStart] Trip already active');
      return;
    }

    // Get current Bluetooth device (might already be connected)
    final deviceName = _connectedBluetoothDevice ?? await _bluetooth.getConnectedDevice();

    if (deviceName == null) {
      print('[AutoStart] No Bluetooth device connected - cannot identify car');
      return;
    }

    // Find matching car
    final car = findCarByDeviceId(deviceName);

    if (car != null) {
      print('[AutoStart] Found car: ${car.name} for device: $deviceName');
      await startTripForCar(car, deviceName);
    } else {
      print('[AutoStart] Unknown device: $deviceName');
      _pendingUnknownDevice = deviceName;
      notifyListeners();
      // Trigger callback for UI to show linking dialog
      onUnknownDevice?.call(deviceName);
    }
  }

  /// Clear pending unknown device (after user links it or dismisses)
  void clearPendingUnknownDevice() {
    _pendingUnknownDevice = null;
    notifyListeners();
  }

  /// Link a device to a car and start trip
  Future<bool> linkDeviceAndStartTrip(String deviceName, Car car) async {
    // Update car with device ID
    try {
      await _api.updateCar(car.id, carplayDeviceId: deviceName);
      // Refresh cars list
      await refreshCars();
      // Clear pending
      _pendingUnknownDevice = null;
      // Start trip for this car
      return await startTripForCar(car, deviceName);
    } catch (e) {
      print('[LinkDevice] Error: $e');
      _error = 'Kon apparaat niet koppelen: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_settingsKey);
      if (data != null) {
        _settings = AppSettings.fromJson(jsonDecode(data) as Map<String, dynamic>);
        _api.updateConfig(_settings.apiUrl, _settings.userEmail);
        // Send config to native for direct API calls
        _background.setApiConfig(_settings.apiUrl, _settings.userEmail);
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
    notifyListeners();
  }

  Future<void> saveSettings(AppSettings newSettings) async {
    _settings = newSettings;
    _api.updateConfig(_settings.apiUrl, _settings.userEmail);
    // Send config to native for direct API calls
    _background.setApiConfig(_settings.apiUrl, _settings.userEmail);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, jsonEncode(_settings.toJson()));
    } catch (e) {
      print('Error saving settings: $e');
    }
    notifyListeners();
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final wasOffline = !_isOnline;
      _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);

      if (wasOffline && _isOnline) {
        // Back online - process queue
        processQueue();
      }
      notifyListeners();
    });
  }

  Future<void> _checkConnectivity() async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    notifyListeners();
  }

  Future<void> refreshQueueLength() async {
    _queueLength = await _offlineQueue.getQueueLength();
    notifyListeners();
  }

  Future<void> processQueue() async {
    final result = await _offlineQueue.processQueue();
    await refreshQueueLength();
    if (result.success > 0) {
      await refreshActiveTrip();
    }
  }

  // ============ Data Refresh ============

  Future<void> refreshActiveTrip() async {
    if (!isConfigured) return;

    try {
      _activeTrip = await _api.getStatus();
      _error = null;
    } catch (e) {
      print('Error refreshing active trip: $e');
      _error = 'Kon actieve rit niet laden';
    }
    notifyListeners();
  }

  Future<void> refreshTrips() async {
    if (!isConfigured) return;

    _isLoadingTrips = true;
    _isLoading = true;
    notifyListeners();

    try {
      final carId = _selectedCarId ?? defaultCar?.id;
      _trips = await _api.getTripsForCar(carId);
      _error = null;
    } catch (e) {
      print('Error refreshing trips: $e');
      _error = 'Kon ritten niet laden';
    }

    _isLoadingTrips = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshStats() async {
    if (!isConfigured) return;

    _isLoadingStats = true;
    notifyListeners();

    try {
      final carId = _selectedCarId ?? defaultCar?.id;
      _stats = await _api.getStatsForCar(carId);
      _error = null;
    } catch (e) {
      print('Error refreshing stats: $e');
    }

    _isLoadingStats = false;
    notifyListeners();
  }

  // ============ Trip CRUD Operations ============

  Future<bool> createTrip(Map<String, dynamic> tripData) async {
    if (!isConfigured) return false;

    try {
      await _api.createTrip(tripData);
      await refreshTrips();
      await refreshStats();
      return true;
    } catch (e) {
      print('Error creating trip: $e');
      _error = 'Kon rit niet aanmaken';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTrip(String tripId, Map<String, dynamic> updates) async {
    if (!isConfigured) return false;

    try {
      await _api.updateTrip(tripId, updates);
      await refreshTrips();
      await refreshStats();
      return true;
    } catch (e) {
      print('Error updating trip: $e');
      _error = 'Kon rit niet bijwerken';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTrip(String tripId) async {
    if (!isConfigured) return false;

    try {
      await _api.deleteTrip(tripId);
      await refreshTrips();
      await refreshStats();
      return true;
    } catch (e) {
      print('Error deleting trip: $e');
      _error = 'Kon rit niet verwijderen';
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshCarData() async {
    if (!isConfigured) return;

    _isLoadingCarData = true;
    notifyListeners();

    try {
      var carId = _selectedCarId;
      if (carId == null || carId.isEmpty) {
        carId = _cars.isNotEmpty ? _cars.first.id : null;
      }
      if (carId != null && carId.isNotEmpty) {
        _carData = await _api.getCarDataById(carId);
      } else {
        _carData = null;
      }
      _error = null;
    } catch (e) {
      print('Error refreshing car data: $e');
      _carData = null;
    }

    _isLoadingCarData = false;
    notifyListeners();
  }

  Future<void> refreshAll() async {
    // First load cars to set selectedCarId
    await refreshCars();
    // Then load trips and stats in parallel
    await Future.wait([
      refreshActiveTrip(),
      refreshTrips(),
      refreshStats(),
    ]);
    // Car data last - needs cars loaded and is slow (Audi API)
    await refreshCarData();
  }

  // ============ Multi-Car Management ============

  Future<void> refreshCars() async {
    if (!isConfigured) return;

    _isLoadingCars = true;
    notifyListeners();

    try {
      _cars = await _api.getCars();
      _error = null;

      // Auto-select default car if none selected
      if (_selectedCarId == null && _cars.isNotEmpty) {
        final car = _cars.firstWhere(
          (c) => c.isDefault,
          orElse: () => _cars.first,
        );
        _selectedCar = car;
        _selectedCarId = car.id;
      }
    } catch (e) {
      print('Error refreshing cars: $e');
    }

    _isLoadingCars = false;
    notifyListeners();
  }

  void selectCar(Car car) {
    _selectedCar = car;
    _selectedCarId = car.id;
    notifyListeners();
    // Refresh all data for selected car
    refreshStats();
    refreshTrips();
    refreshCarData();
  }

  Future<Car> createCar({
    required String name,
    String brand = 'other',
    String color = '#3B82F6',
    String icon = 'car',
  }) async {
    final car = await _api.createCar(
      name: name,
      brand: brand,
      color: color,
      icon: icon,
    );
    await refreshCars();
    return car;
  }

  Future<void> updateCar(String carId, {
    String? name,
    String? brand,
    String? color,
    String? icon,
    bool? isDefault,
    String? carplayDeviceId,
  }) async {
    await _api.updateCar(
      carId,
      name: name,
      brand: brand,
      color: color,
      icon: icon,
      isDefault: isDefault,
      carplayDeviceId: carplayDeviceId,
    );
    await refreshCars();
  }

  Future<void> deleteCar(String carId) async {
    await _api.deleteCar(carId);
    // If deleted car was selected, clear selection
    if (_selectedCarId == carId) {
      _selectedCar = null;
      _selectedCarId = null;
    }
    await refreshCars();
  }

  Future<void> saveCarCredentials(String carId, CarCredentials creds) async {
    await _api.saveCarCredentials(carId, creds);
    await refreshCars();
  }

  Future<Map<String, dynamic>?> getCarCredentials(String carId) async {
    return await _api.getCarCredentials(carId);
  }

  Future<void> deleteCarCredentials(String carId) async {
    await _api.deleteCarCredentials(carId);
    await refreshCars();
  }

  Future<Map<String, dynamic>> testCarCredentials(String carId, CarCredentials creds) async {
    return await _api.testCarCredentials(carId, creds);
  }

  Future<String?> getTeslaAuthUrl(String carId) async {
    return await _api.getTeslaAuthUrl(carId);
  }

  Future<bool> completeTeslaAuth(String carId, String callbackUrl) async {
    final success = await _api.completeTeslaAuth(carId, callbackUrl);
    // Don't refresh cars here - let the screen show success state first
    return success;
  }

  // Audi OAuth
  Future<String?> getAudiAuthUrl(String carId) async {
    return await _api.getAudiAuthUrl(carId);
  }

  Future<Map<String, dynamic>> completeAudiAuth(String carId, String redirectUrl) async {
    final result = await _api.completeAudiAuth(carId, redirectUrl);
    // Don't refresh cars here - let the screen show success state first
    // Cars will refresh when user navigates back
    return result;
  }

  // VW Group OAuth (Volkswagen, Skoda, SEAT, CUPRA)
  Future<Map<String, dynamic>> getVWGroupAuthUrl(String carId, String brand) async {
    return await _api.getVWGroupAuthUrl(carId, brand);
  }

  Future<Map<String, dynamic>> completeVWGroupAuth(String carId, String brand, String redirectUrl) async {
    final result = await _api.completeVWGroupAuth(carId, brand, redirectUrl);
    // Don't refresh cars here - let the screen show success state first
    return result;
  }

  // Renault OAuth (Gigya-based)
  Future<Map<String, dynamic>> renaultDirectLogin(String carId, String username, String password, {String locale = 'nl_NL'}) async {
    final result = await _api.renaultDirectLogin(carId, username, password, locale: locale);
    return result;
  }

  Future<Map<String, dynamic>> getRenaultAuthUrl(String carId, {String locale = 'nl/nl'}) async {
    return await _api.getRenaultAuthUrl(carId, locale: locale);
  }

  Future<Map<String, dynamic>> completeRenaultAuth(String carId, String gigyaToken, {String? personId}) async {
    final result = await _api.completeRenaultAuth(carId, gigyaToken, personId: personId);
    // Don't refresh cars here - let the screen show success state first
    return result;
  }

  // ============ Webhook Actions ============

  /// Start trip for a specific car with device ID
  Future<bool> startTripForCar(Car car, String deviceId) async {
    final location = await _location.getCurrentLocation();
    if (location == null) {
      _error = _location.lastError ?? 'Kon locatie niet bepalen';
      notifyListeners();
      return false;
    }

    if (!_isOnline) {
      await _offlineQueue.addToQueue('start', location.lat, location.lng, deviceId: deviceId);
      await refreshQueueLength();
      _startBackgroundTracking();
      return true;
    }

    try {
      await _api.startTrip(location.lat, location.lng, deviceId: deviceId);
      await refreshActiveTrip();
      _startBackgroundTracking();
      return true;
    } catch (e) {
      await _offlineQueue.addToQueue('start', location.lat, location.lng, deviceId: deviceId);
      await refreshQueueLength();
      _startBackgroundTracking();
      return true;
    }
  }

  /// Manual start trip - requires Bluetooth device to be connected
  Future<bool> startTrip() async {
    // Get current Bluetooth device
    final deviceName = _connectedBluetoothDevice ?? await _bluetooth.getConnectedDevice();

    if (deviceName == null) {
      _error = 'Geen Bluetooth apparaat verbonden. Verbind met je auto om een rit te starten.';
      notifyListeners();
      return false;
    }

    // Find matching car
    final car = findCarByDeviceId(deviceName);

    if (car == null) {
      // Unknown device - trigger linking flow
      _pendingUnknownDevice = deviceName;
      notifyListeners();
      onUnknownDevice?.call(deviceName);
      return false;
    }

    return await startTripForCar(car, deviceName);
  }

  void _startBackgroundTracking() {
    print('[Background] Starting background GPS tracking...');
    _location.startBackgroundTracking(
      onLocationUpdate: (location) async {
        print('[Background] Ping callback: ${location.lat}, ${location.lng}');
        await _sendBackgroundPing(location.lat, location.lng);
      },
      pingInterval: const Duration(minutes: 1),
    );
  }

  Future<void> _sendBackgroundPing(double lat, double lng) async {
    // First check if trip is still active (backend may have ended it)
    try {
      await refreshActiveTrip();
      if (_activeTrip?.active != true) {
        print('[Background] Trip ended by backend - stopping tracking');
        _location.stopBackgroundTracking();
        notifyListeners();
        return;
      }
    } catch (e) {
      print('[Background] Error checking trip status: $e');
    }

    if (!_isOnline) {
      print('[Background] Offline - adding ping to queue');
      await _offlineQueue.addToQueue('ping', lat, lng);
      await refreshQueueLength();
      return;
    }

    try {
      print('[Background] Sending ping to API...');
      await _api.sendPing(lat, lng);
      print('[Background] Ping sent successfully');
    } catch (e) {
      print('[Background] Error sending ping: $e');
      await _offlineQueue.addToQueue('ping', lat, lng);
      await refreshQueueLength();
    }
  }

  Future<bool> endTrip() async {
    // Stop background tracking first
    _location.stopBackgroundTracking();
    print('[Background] Stopped background tracking');

    final location = await _location.getCurrentLocation();
    if (location == null) {
      _error = _location.lastError ?? 'Kon locatie niet bepalen';
      notifyListeners();
      return false;
    }

    if (!_isOnline) {
      await _offlineQueue.addToQueue('end', location.lat, location.lng);
      await refreshQueueLength();
      return true;
    }

    try {
      await _api.endTrip(location.lat, location.lng);
      await refreshActiveTrip();
      return true;
    } catch (e) {
      print('Error ending trip: $e');
      await _offlineQueue.addToQueue('end', location.lat, location.lng);
      await refreshQueueLength();
      return true;
    }
  }

  Future<bool> sendPing() async {
    final location = await _location.getCurrentLocation();
    if (location == null) {
      _error = _location.lastError ?? 'Kon locatie niet bepalen';
      notifyListeners();
      return false;
    }

    if (!_isOnline) {
      await _offlineQueue.addToQueue('ping', location.lat, location.lng);
      await refreshQueueLength();
      return true;
    }

    try {
      await _api.sendPing(location.lat, location.lng);
      await refreshActiveTrip();
      return true;
    } catch (e) {
      print('Error sending ping: $e');
      await _offlineQueue.addToQueue('ping', location.lat, location.lng);
      await refreshQueueLength();
      return true;
    }
  }

  Future<bool> finalizeTrip() async {
    _location.stopBackgroundTracking();
    try {
      await _api.finalize();
      await refreshActiveTrip();
      await refreshTrips();
      return true;
    } catch (e) {
      print('Error finalizing trip: $e');
      _error = 'Kon rit niet afronden';
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelTrip() async {
    _location.stopBackgroundTracking();
    try {
      await _api.cancel();
      await refreshActiveTrip();
      return true;
    } catch (e) {
      print('Error canceling trip: $e');
      _error = 'Kon rit niet annuleren';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

}
