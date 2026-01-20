// App orchestration provider - coordinates other providers

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../core/analytics/analytics_service.dart';
import '../core/logging/app_logger.dart';
import '../core/logging/crashlytics_logger.dart';
import '../models/car.dart';
import '../models/location.dart';
import '../models/settings.dart';
import '../models/trip.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'car_provider.dart';
import 'connectivity_provider.dart';
import 'settings_provider.dart';
import 'trip_provider.dart';

// Callback for unknown device - used to trigger car linking flow
typedef UnknownDeviceCallback = void Function(String deviceName);

/// Thin orchestrator that coordinates specialized providers.
///
/// After extraction of SettingsProvider, CarProvider, ConnectivityProvider, and TripProvider,
/// AppProvider handles:
/// - Navigation state
/// - Cross-provider coordination (auto-start trips, device linking)
/// - Auth setup and token refresh callbacks
class AppProvider extends ChangeNotifier {
  AppProvider(
    this._settingsProvider,
    this._carProvider,
    this._connectivityProvider,
    this._tripProvider,
    this._api,
  ) {
    // Fire and forget - don't block constructor
    Future.microtask(_init);
  }

  static const _log = AppLogger('AppProvider');

  // Provider dependencies
  final SettingsProvider _settingsProvider;
  final CarProvider _carProvider;
  final ConnectivityProvider _connectivityProvider;
  final TripProvider _tripProvider;

  // Services (shared ApiService from provider tree)
  final ApiService _api;

  // Navigation state
  int _navigationIndex = 0;

  // Callback for unknown device - set this to receive device link requests
  UnknownDeviceCallback? onUnknownDevice;

  // ============ Delegating Getters - Settings ============

  AppSettings get settings => _settingsProvider.settings;
  bool get isConfigured => _settingsProvider.isConfigured;

  // ============ Delegating Getters - Connectivity ============

  int get queueLength => _connectivityProvider.queueLength;
  bool get isOnline => _connectivityProvider.isOnline;
  bool get isCarPlayConnected => _connectivityProvider.isCarPlayConnected;
  bool get isBluetoothConnected => _connectivityProvider.isBluetoothConnected;
  String? get connectedBluetoothDevice => _connectivityProvider.connectedBluetoothDevice;
  String? get pendingUnknownDevice => _connectivityProvider.pendingUnknownDevice;

  // ============ Delegating Getters - Car ============

  List<Car> get cars => _carProvider.cars;
  Car? get selectedCar => _carProvider.selectedCar;
  String? get selectedCarId => _carProvider.selectedCarId;
  Car? get defaultCar => _carProvider.defaultCar;
  CarData? get carData => _carProvider.carData;
  bool get isLoadingCars => _carProvider.isLoadingCars;
  bool get isLoadingCarData => _carProvider.isLoadingCarData;

  // ============ Delegating Getters - Trip ============

  ActiveTrip? get activeTrip => _tripProvider.activeTrip;
  List<Trip> get trips => _tripProvider.trips;
  Stats? get stats => _tripProvider.stats;
  List<UserLocation> get locations => _tripProvider.locations;
  bool get isLoading => _tripProvider.isLoading;
  bool get isLoadingStats => _tripProvider.isLoadingStats;
  bool get isLoadingTrips => _tripProvider.isLoadingTrips;
  String? get error => _tripProvider.error;
  bool get isTrackingLocation => _tripProvider.isTrackingLocation;

  // ============ Delegating Methods - Car ============

  void selectCar(Car car) => _carProvider.selectCar(car);
  Future<void> refreshCars() => _carProvider.refreshCars();
  Future<void> refreshCarData() => _carProvider.refreshCarData();

  // ============ Delegating Methods - Trip ============

  Future<void> refreshActiveTrip() => _tripProvider.refreshActiveTrip();
  Future<void> refreshTrips() => _tripProvider.refreshTrips();
  Future<void> refreshStats() => _tripProvider.refreshStats();
  Future<void> refreshLocations() => _tripProvider.refreshLocations();
  Future<bool> createTrip(Map<String, dynamic> tripData) => _tripProvider.createTrip(tripData);
  Future<bool> updateTrip(String tripId, Map<String, dynamic> updates) =>
      _tripProvider.updateTrip(tripId, updates);
  Future<bool> deleteTrip(String tripId) => _tripProvider.deleteTrip(tripId);
  bool isKnownLocation(String? address) => _tripProvider.isKnownLocation(address);
  Future<bool> addLocation({
    required String name,
    required double lat,
    required double lng,
  }) =>
      _tripProvider.addLocation(name: name, lat: lat, lng: lng);
  Future<bool> startTrip() => _tripProvider.startTrip();
  Future<bool> startTripForCar(Car car, String deviceId) => _tripProvider.startTripForCar(car, deviceId);
  Future<bool> endTrip() => _tripProvider.endTrip();
  Future<bool> sendPing() => _tripProvider.sendPing();
  Future<bool> finalizeTrip() => _tripProvider.finalizeTrip();
  Future<bool> cancelTrip() => _tripProvider.cancelTrip();
  void clearError() => _tripProvider.clearError();
  Future<void> deleteAccount() => _tripProvider.deleteAccount();

  // ============ Delegating Methods - Connectivity ============

  Future<void> refreshQueueLength() => _connectivityProvider.refreshQueueLength();
  Future<void> processQueue() async {
    final result = await _connectivityProvider.processQueue();
    if (result.success > 0) {
      await _tripProvider.refreshActiveTrip();
    }
  }

  void clearPendingUnknownDevice() => _connectivityProvider.clearPendingUnknownDevice();

  // ============ Navigation ============

  int get navigationIndex => _navigationIndex;

  void navigateTo(int index) {
    _navigationIndex = index;
    notifyListeners();
  }

  // ============ Initialization ============

  Future<void> _init() async {
    // Settings already loaded by SettingsProvider
    // Update API config in case settings loaded after constructor
    _api.updateConfig(_settingsProvider.apiUrl, _settingsProvider.userEmail);

    // Initialize TripProvider (notifications, etc.)
    await _tripProvider.init();

    // Set up cross-provider callbacks for connectivity events
    _connectivityProvider.onCarPlayConnected = _tryAutoStartTrip;
    _connectivityProvider.onBluetoothDeviceConnected = (deviceName) {
      _syncCarIdToNative(deviceName);
      _tryAutoStartTrip();
    };
    _connectivityProvider.onUnknownDevice = (deviceName) {
      onUnknownDevice?.call(deviceName);
    };

    // Setup background listener (trip-related)
    _setupBackgroundListener();

    // Wait for auth to initialize before loading data
    final auth = AuthService();
    await auth.init();

    // Sync Google auth email to settings and App Group
    if (auth.isSignedIn && auth.userEmail != null && auth.userEmail != settings.userEmail) {
      await saveSettings(settings.copyWith(userEmail: auth.userEmail));
    }

    // Set Crashlytics user identifier for crash debugging
    if (auth.isSignedIn && auth.userEmail != null) {
      CrashlyticsLogger.setUserIdentifier(auth.userEmail!);
      CrashlyticsLogger.log('User signed in');
      // Set Analytics user ID (hashed for privacy)
      final emailHash = sha256.convert(utf8.encode(auth.userEmail!)).toString();
      AnalyticsService.setUserId(emailHash);
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
      unawaited(_tripProvider.checkAndResumeTracking());
    }
  }

  /// Sync car_id to native iOS based on Bluetooth device
  void _syncCarIdToNative(String deviceName) {
    final car = _carProvider.findCarByDeviceId(deviceName);
    if (car != null) {
      _log.info('Found car ${car.name} (${car.id}) - syncing to native');
      _tripProvider.backgroundService.setActiveCarId(car.id);
    } else {
      _log.info('Unknown device $deviceName - no car_id to sync');
      _tripProvider.backgroundService.clearActiveCarId();
    }
  }

  void _setupBackgroundListener() {
    // NOTE: Don't call _background.startMonitoring() here!
    // It's called from main.dart after onboarding completes to avoid
    // triggering location permission before user goes through onboarding.

    // Listen for car detection events from background (motion detection)
    // Note: Native iOS already calls the API directly, this is just for UI updates
    _tripProvider.backgroundService.setCarDetectedCallback((deviceName, lat, lng) async {
      _log.info('Car detected callback: $deviceName at $lat, $lng');

      // "Motion" means motion detection triggered - native iOS already started the trip
      // Just refresh the active trip state
      if (deviceName == 'Motion') {
        _log.info('Motion detection - refreshing trip state');
        await _tripProvider.refreshActiveTrip();
        notifyListeners();
        return;
      }

      // For actual Bluetooth device names, check if linked to a car
      final car = _carProvider.findCarByDeviceId(deviceName);
      if (car == null) {
        _log.info('Unknown Bluetooth device: $deviceName');
        _connectivityProvider.setPendingUnknownDevice(deviceName);
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
    if (_tripProvider.activeTrip?.active ?? false) {
      _log.info('Trip already active');
      return;
    }

    // PRIORITY 1: Check Bluetooth FIRST - this identifies the specific car
    final deviceName =
        _connectivityProvider.connectedBluetoothDevice ?? await _connectivityProvider.getConnectedDevice();

    if (deviceName != null) {
      // Find car matching this Bluetooth device
      final matchedCar = _carProvider.findCarByDeviceId(deviceName);

      if (matchedCar != null) {
        // Bluetooth identifies the car - start trip for this specific car
        _log.info('Bluetooth identified car: ${matchedCar.name} for device: $deviceName');
        await _tripProvider.startTripForCar(matchedCar, deviceName);
        return;
      } else {
        // Unknown Bluetooth device - ask user to link it
        _log.info('Unknown Bluetooth device: $deviceName - prompting user to link');
        _connectivityProvider.setPendingUnknownDevice(deviceName);
        // Show push notification for background awareness
        unawaited(_tripProvider.notificationService.showUnknownDeviceNotification(deviceName));
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

  /// Link a device to a car and start trip
  Future<bool> linkDeviceAndStartTrip(String deviceName, Car car) async {
    // Update car with device ID via CarProvider
    try {
      await _carProvider.updateCar(car.id, carplayDeviceId: deviceName);
      // Clear pending
      _connectivityProvider.clearPendingUnknownDevice();
      // Show notification that car is linked
      unawaited(_tripProvider.notificationService.showCarLinkedNotification(car.name, deviceName));
      // Sync car_id to native for future trips
      unawaited(_tripProvider.backgroundService.setActiveCarId(car.id));
      // Start trip for this car
      return _tripProvider.startTripForCar(car, deviceName);
    } on Exception catch (e) {
      _log.error('LinkDevice error', e);
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

  /// Refresh all data from all providers
  Future<void> refreshAll() async {
    // First load cars to set selectedCarId
    await _carProvider.refreshCars();
    // Then load trips, stats, and locations in parallel
    await _tripProvider.refreshAll();
    // Car data last - needs cars loaded and is slow (Audi API)
    await _carProvider.refreshCarData();
  }
}
