// App state provider

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../core/logging/app_logger.dart';
import '../models/car.dart';
import '../models/location.dart';
import '../models/settings.dart';
import '../models/trip.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/background_service.dart';
import '../services/bluetooth_service.dart';
import '../services/carplay_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/offline_queue.dart';
import 'car_provider.dart';
import 'settings_provider.dart';

// Callback for unknown device - used to trigger car linking flow
typedef UnknownDeviceCallback = void Function(String deviceName);

class AppProvider extends ChangeNotifier {
  AppProvider(this._settingsProvider, this._carProvider) {
    _api = ApiService(
      baseUrl: _settingsProvider.apiUrl,
      userEmail: _settingsProvider.userEmail,
    );
    _location = LocationService();
    _offlineQueue = OfflineQueue(_api);
    _carPlay = CarPlayService();
    _bluetooth = BluetoothService();
    _background = BackgroundService();
    _notifications = NotificationService();
    // Fire and forget - don't block constructor
    Future.microtask(_init);
  }

  static const _log = AppLogger('AppProvider');

  // Provider dependencies
  final SettingsProvider _settingsProvider;
  final CarProvider _carProvider;

  // Services
  late ApiService _api;
  late LocationService _location;
  late OfflineQueue _offlineQueue;
  late CarPlayService _carPlay;
  late BluetoothService _bluetooth;
  late BackgroundService _background;
  late NotificationService _notifications;

  // State
  ActiveTrip? _activeTrip;
  List<Trip> _trips = [];
  Stats? _stats;
  List<UserLocation> _locations = [];
  bool _isLoading = false;
  String? _error;
  int _queueLength = 0;
  bool _isOnline = true;
  bool _isCarPlayConnected = false;
  bool _isBluetoothConnected = false;
  String? _connectedBluetoothDevice;
  String? _pendingUnknownDevice; // Device waiting to be linked to a car

  // Loading states for each section (start true so spinners show on boot)
  bool _isLoadingStats = true;
  bool _isLoadingTrips = true;

  // Navigation state
  int _navigationIndex = 0;

  // Callback for unknown device
  UnknownDeviceCallback? onUnknownDevice;

  // Getters - delegate to SettingsProvider
  AppSettings get settings => _settingsProvider.settings;
  bool get isConfigured => _settingsProvider.isConfigured;
  ActiveTrip? get activeTrip => _activeTrip;
  List<Trip> get trips => _trips;
  Stats? get stats => _stats;
  List<UserLocation> get locations => _locations;
  bool get isLoading => _isLoading;
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

  // Delegate car getters to CarProvider
  List<Car> get cars => _carProvider.cars;
  Car? get selectedCar => _carProvider.selectedCar;
  String? get selectedCarId => _carProvider.selectedCarId;
  Car? get defaultCar => _carProvider.defaultCar;
  CarData? get carData => _carProvider.carData;
  bool get isLoadingCars => _carProvider.isLoadingCars;
  bool get isLoadingCarData => _carProvider.isLoadingCarData;

  // Navigation getter
  int get navigationIndex => _navigationIndex;

  // Navigate to a specific tab
  void navigateTo(int index) {
    _navigationIndex = index;
    notifyListeners();
  }

  Future<void> _init() async {
    // Settings already loaded by SettingsProvider
    // Update API config in case settings loaded after constructor
    _api.updateConfig(_settingsProvider.apiUrl, _settingsProvider.userEmail);

    // Initialize notifications (permissions handled by onboarding)
    await _notifications.init();

    // Setup listeners
    _listenToConnectivity();
    _setupCarPlayListener();
    _setupBluetoothListener();
    _setupBackgroundListener();
    unawaited(_checkConnectivity());

    // Wait for auth to initialize before loading data
    final auth = AuthService();
    await auth.init();

    // Sync Google auth email to settings and App Group
    if (auth.isSignedIn && auth.userEmail != null && auth.userEmail != settings.userEmail) {
      await saveSettings(settings.copyWith(userEmail: auth.userEmail));
    }

    // CRITICAL: Set auth token on API service
    if (auth.isSignedIn && auth.accessToken != null) {
      _api.setAuthToken(auth.accessToken);
    }

    // Set up token refresh callback for 401 handling
    _api.setTokenRefreshCallback(() async {
      _log.info('Token refresh requested by API client');
      final newToken = await auth.refreshTokenForApi();
      if (newToken != null) {
        // Also sync the refreshed token to Watch
        await auth.syncTokenToWatch();
      }
      return newToken;
    });

    // Always sync fresh token to Keychain for Watch app
    if (auth.isSignedIn) {
      await auth.syncTokenToWatch();
    }

    // Load data in background
    if (isConfigured) {
      unawaited(refreshAll());
      // Resume tracking if there was an active trip
      unawaited(_checkAndResumeTracking());
    }
  }

  Future<void> _checkAndResumeTracking() async {
    try {
      await refreshActiveTrip();
      if (_activeTrip?.active ?? false) {
        _log.info('Active trip detected on startup, resuming tracking');
        await _background.startTrip();
      }
    } on Exception catch (e) {
      _log.error('Error checking active trip', e);
    }
  }

  void _setupCarPlayListener() {
    // Check initial CarPlay status
    _carPlay.checkConnection().then((connected) {
      _isCarPlayConnected = connected;
      notifyListeners();
    });

    // Listen for CarPlay connection changes
    _carPlay.setConnectionCallback(({required bool connected}) {
      _isCarPlayConnected = connected;
      notifyListeners();

      if (connected) {
        _log.info('CarPlay connected - checking for auto-start...');
        _tryAutoStartTrip();
      } else {
        // When CarPlay disconnects, keep tracking - backend will end trip
        _log.info('CarPlay disconnected - keeping trip active, backend will end when parked');
      }
    });
  }

  void _setupBluetoothListener() {
    // Check initial Bluetooth status
    _bluetooth.getConnectedDevice().then((deviceName) {
      _connectedBluetoothDevice = deviceName;
      _isBluetoothConnected = deviceName != null;
      if (deviceName != null) {
        _syncCarIdToNative(deviceName);
      }
      notifyListeners();
    });

    // Listen for Bluetooth connection changes
    _bluetooth.setConnectionCallback((deviceName) {
      _connectedBluetoothDevice = deviceName;
      _isBluetoothConnected = deviceName != null;
      notifyListeners();

      if (deviceName != null) {
        _log.info('Bluetooth connected: $deviceName - syncing car_id to native...');
        _syncCarIdToNative(deviceName);
        _tryAutoStartTrip();
      } else {
        _log.info('Bluetooth disconnected - clearing car_id from native');
        _background.clearActiveCarId();
      }
    });
  }

  /// Sync car_id to native iOS based on Bluetooth device
  void _syncCarIdToNative(String deviceName) {
    final car = _carProvider.findCarByDeviceId(deviceName);
    if (car != null) {
      _log.info('Found car ${car.name} (${car.id}) - syncing to native');
      _background.setActiveCarId(car.id);
    } else {
      _log.info('Unknown device $deviceName - no car_id to sync');
      _background.clearActiveCarId();
    }
  }

  void _setupBackgroundListener() {
    // NOTE: Don't call _background.startMonitoring() here!
    // It's called from main.dart after onboarding completes to avoid
    // triggering location permission before user goes through onboarding.

    // Listen for car detection events from background (motion detection)
    // Note: Native iOS already calls the API directly, this is just for UI updates
    _background.setCarDetectedCallback((deviceName, lat, lng) async {
        _log.info('Car detected callback: $deviceName at $lat, $lng');

        // "Motion" means motion detection triggered - native iOS already started the trip
        // Just refresh the active trip state
        if (deviceName == 'Motion') {
          _log.info('Motion detection - refreshing trip state');
          await refreshActiveTrip();
          notifyListeners();
          return;
        }

        // For actual Bluetooth device names, update state
        _connectedBluetoothDevice = deviceName;
        _isBluetoothConnected = true;
        notifyListeners();

        // Check if this device is linked to a car
        final car = _carProvider.findCarByDeviceId(deviceName);
        if (car == null) {
          _log.info('Unknown Bluetooth device: $deviceName');
          _pendingUnknownDevice = deviceName;
          notifyListeners();
          onUnknownDevice?.call(deviceName);
        }
      });
  }

  /// Try to auto-start trip when CarPlay or Bluetooth connects
  /// For cars with API support, motion detection handles this automatically
  Future<void> _tryAutoStartTrip() async {
    if (!settings.autoDetectCar || !isConfigured) {
      _log.info('AutoStart disabled or not configured');
      return;
    }

    // Already have an active trip? Don't start another
    if (_activeTrip?.active ?? false) {
      _log.info('Trip already active');
      return;
    }

    // PRIORITY 1: Check Bluetooth FIRST - this identifies the specific car
    final deviceName = _connectedBluetoothDevice ?? await _bluetooth.getConnectedDevice();

    if (deviceName != null) {
      // Find car matching this Bluetooth device
      final matchedCar = _carProvider.findCarByDeviceId(deviceName);

      if (matchedCar != null) {
        // Bluetooth identifies the car - start trip for this specific car
        _log.info('Bluetooth identified car: ${matchedCar.name} for device: $deviceName');
        await startTripForCar(matchedCar, deviceName);
        return;
      } else {
        // Unknown Bluetooth device - ask user to link it
        _log.info('Unknown Bluetooth device: $deviceName - prompting user to link');
        _pendingUnknownDevice = deviceName;
        notifyListeners();
        // Show push notification for background awareness
        unawaited(_notifications.showUnknownDeviceNotification(deviceName));
        // Trigger UI callback for foreground dialog
        onUnknownDevice?.call(deviceName);
        return;
      }
    }

    // PRIORITY 2: No Bluetooth - fall back to motion detection for cars with API
    final car = defaultCar;
    if (car != null && car.brand != 'other') {
      _log.info('No Bluetooth, but default car has API - motion detection will handle trip start');
      return;
    }

    // No Bluetooth AND no API support - cannot identify car
    _log.info('No Bluetooth device connected and no API support - cannot identify car');
  }

  /// Clear pending unknown device (after user links it or dismisses)
  void clearPendingUnknownDevice() {
    _pendingUnknownDevice = null;
    notifyListeners();
  }

  /// Link a device to a car and start trip
  Future<bool> linkDeviceAndStartTrip(String deviceName, Car car) async {
    // Update car with device ID via CarProvider
    try {
      await _carProvider.updateCar(car.id, carplayDeviceId: deviceName);
      // Clear pending
      _pendingUnknownDevice = null;
      // Show notification that car is linked
      unawaited(_notifications.showCarLinkedNotification(car.name, deviceName));
      // Sync car_id to native for future trips
      unawaited(_background.setActiveCarId(car.id));
      // Start trip for this car
      return startTripForCar(car, deviceName);
    } on Exception catch (e) {
      _log.error('LinkDevice error', e);
      _error = 'Kon apparaat niet koppelen: $e';
      notifyListeners();
      return false;
    }
  }

  /// Save settings via SettingsProvider and update API config
  Future<void> saveSettings(AppSettings newSettings) async {
    await _settingsProvider.saveSettings(newSettings);
    _api.updateConfig(_settingsProvider.apiUrl, _settingsProvider.userEmail);
    notifyListeners();
  }

  /// Set auth token on API service (call after sign in)
  void setAuthToken(String token) {
    _api.setAuthToken(token);
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) {
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
    final results = await Connectivity().checkConnectivity();
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
    } on Exception catch (e) {
      _log.error('Error refreshing active trip', e);
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
      final carId = selectedCarId ?? defaultCar?.id;
      _trips = await _api.getTripsForCar(carId);
      _error = null;
    } on Exception catch (e) {
      _log.error('Error refreshing trips', e);
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
      final carId = selectedCarId ?? defaultCar?.id;
      _stats = await _api.getStatsForCar(carId);
      _error = null;
    } on Exception catch (e) {
      _log.error('Error refreshing stats', e);
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
    } on Exception catch (e) {
      _log.error('Error creating trip', e);
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
    } on Exception catch (e) {
      _log.error('Error updating trip', e);
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
    } on Exception catch (e) {
      _log.error('Error deleting trip', e);
      _error = 'Kon rit niet verwijderen';
      notifyListeners();
      return false;
    }
  }

  // ============ Location Management ============

  Future<void> refreshLocations() async {
    if (!isConfigured) return;

    try {
      _locations = await _api.getLocations();
      _error = null;
    } on Exception catch (e) {
      _log.error('Error refreshing locations', e);
    }
    notifyListeners();
  }

  /// Check if an address is a known location
  bool isKnownLocation(String? address) {
    if (address == null || address.isEmpty) return false;
    final lower = address.toLowerCase();
    // Built-in locations
    if (lower == 'thuis' || lower == 'home' || lower == 'kantoor' || lower == 'office') {
      return true;
    }
    // User-defined locations
    return _locations.any((loc) => loc.name.toLowerCase() == lower);
  }

  /// Add a new named location
  Future<bool> addLocation({
    required String name,
    required double lat,
    required double lng,
  }) async {
    if (!isConfigured) return false;

    try {
      await _api.addLocation(name: name, lat: lat, lng: lng);
      await refreshLocations();
      await refreshTrips(); // Trips get updated with new location name
      return true;
    } on Exception catch (e) {
      _log.error('Error adding location', e);
      _error = 'Kon locatie niet opslaan';
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshAll() async {
    // First load cars to set selectedCarId
    await _carProvider.refreshCars();
    // Then load trips, stats, and locations in parallel
    await Future.wait([
      refreshActiveTrip(),
      refreshTrips(),
      refreshStats(),
      refreshLocations(),
    ]);
    // Car data last - needs cars loaded and is slow (Audi API)
    await _carProvider.refreshCarData();
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
      await _background.startTrip();
      return true;
    }

    try {
      await _api.startTrip(location.lat, location.lng, deviceId: deviceId);
      await refreshActiveTrip();
      await _background.startTrip();
      await _background.notifyWatchTripStarted();
      // Show trip started notification
      unawaited(_notifications.showTripStartedNotification(car.name));
      return true;
    } on Exception {
      await _offlineQueue.addToQueue('start', location.lat, location.lng, deviceId: deviceId);
      await refreshQueueLength();
      await _background.startTrip();
      // Show trip started notification even in offline mode
      unawaited(_notifications.showTripStartedNotification(car.name));
      return true;
    }
  }

  /// Manual start trip
  /// - For cars with API (audi, vw, tesla, etc.): uses motion detection, no Bluetooth needed
  /// - For cars without API: requires Bluetooth to identify which car
  Future<bool> startTrip() async {
    // Check if we have a selected car
    final car = selectedCar ?? defaultCar;

    if (car == null) {
      _error = 'Geen auto geselecteerd. Voeg eerst een auto toe.';
      notifyListeners();
      return false;
    }

    // Check if car has API support (known brand with potential API)
    final hasApiSupport = car.brand != 'other';

    // Try Bluetooth first (works for all cars)
    final deviceName = _connectedBluetoothDevice ?? await _bluetooth.getConnectedDevice();

    if (deviceName != null) {
      // Bluetooth connected - find matching car or use current
      final matchedCar = _carProvider.findCarByDeviceId(deviceName);

      if (matchedCar != null) {
        return startTripForCar(matchedCar, deviceName);
      } else {
        // Unknown device - trigger linking flow
        _pendingUnknownDevice = deviceName;
        notifyListeners();
        onUnknownDevice?.call(deviceName);
        return false;
      }
    }

    // No Bluetooth - check if car has API support
    if (hasApiSupport) {
      // Car with API support - motion detection handles identification
      return startTripForCar(car, 'Motion');
    }

    // No Bluetooth AND no API support - show helpful error with steps
    _error = 'We kunnen niet detecteren welke auto je bestuurt.\n\n'
        'Stel je auto in:\n\n'
        'Auto-API koppelen\n'
        'Ga naar Autos -> ${car.name} -> koppel je account voor kilometerstand en meer.\n\n'
        'Bluetooth koppelen\n'
        'Verbind je telefoon via Bluetooth met je auto, open deze app en koppel in de melding.\n\n'
        'Tip: Stel beide in voor de beste betrouwbaarheid!';
    notifyListeners();
    return false;
  }

  Future<bool> endTrip() async {
    // Stop native tracking + Live Activity
    await _background.endTrip();

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
    } on Exception catch (e) {
      _log.error('Error ending trip', e);
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
    } on Exception catch (e) {
      _log.error('Error sending ping', e);
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
    } on Exception catch (e) {
      _log.error('Error finalizing trip', e);
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
    } on Exception catch (e) {
      _log.error('Error canceling trip', e);
      _error = 'Kon rit niet annuleren';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ============ Account Management ============

  /// Delete the current user's account and all associated data.
  /// This is permanent and cannot be undone.
  Future<void> deleteAccount() async {
    await _api.deleteAccount();
  }
}
