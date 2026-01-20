// Trip state provider - manages trip lifecycle, CRUD, and webhook operations

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/analytics/analytics_service.dart';
import '../core/logging/app_logger.dart';
import '../core/logging/crashlytics_logger.dart';
import '../models/car.dart';
import '../models/location.dart';
import '../models/trip.dart';
import '../services/api_service.dart';
import '../services/background_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import 'car_provider.dart';
import 'connectivity_provider.dart';

/// Provider for trip lifecycle management.
///
/// Manages:
/// - Active trip state and tracking
/// - Trip CRUD operations
/// - Stats and location data
/// - Webhook operations (start, end, ping, finalize, cancel)
class TripProvider extends ChangeNotifier {
  TripProvider(this._api, this._carProvider, this._connectivityProvider) {
    _location = LocationService();
    _background = BackgroundService();
    _notifications = NotificationService();
  }

  static const _log = AppLogger('TripProvider');

  // Dependencies
  final ApiService _api;
  final CarProvider _carProvider;
  final ConnectivityProvider _connectivityProvider;

  // Services (owned by TripProvider)
  late LocationService _location;
  late BackgroundService _background;
  late NotificationService _notifications;

  // ============ State ============

  ActiveTrip? _activeTrip;
  List<Trip> _trips = [];
  Stats? _stats;
  List<UserLocation> _locations = [];
  bool _isLoading = false;
  String? _error;

  // Loading states for each section (start true so spinners show on boot)
  bool _isLoadingStats = true;
  bool _isLoadingTrips = true;

  // ============ Callbacks ============

  /// Called when a trip starts - AppProvider sets this for UI coordination
  VoidCallback? onTripStarted;

  /// Called when a trip ends - AppProvider sets this for UI coordination
  VoidCallback? onTripEnded;

  // ============ Getters ============

  ActiveTrip? get activeTrip => _activeTrip;
  List<Trip> get trips => _trips;
  Stats? get stats => _stats;
  List<UserLocation> get locations => _locations;
  bool get isLoading => _isLoading;
  bool get isLoadingStats => _isLoadingStats;
  bool get isLoadingTrips => _isLoadingTrips;
  String? get error => _error;
  bool get isTrackingLocation => _location.isTracking;

  /// Expose background service for AppProvider's background listener setup
  BackgroundService get backgroundService => _background;

  /// Expose notification service for AppProvider's notifications
  NotificationService get notificationService => _notifications;

  // ============ Initialization ============

  /// Initialize TripProvider - call after construction
  Future<void> init() async {
    // Initialize notifications (permissions handled by onboarding)
    await _notifications.init();
  }

  /// Check if there's an active trip and resume tracking
  Future<void> checkAndResumeTracking() async {
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

  // ============ Data Refresh ============

  Future<void> refreshActiveTrip() async {
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
    _isLoadingTrips = true;
    _isLoading = true;
    notifyListeners();

    try {
      final carId = _carProvider.selectedCarId ?? _carProvider.defaultCar?.id;
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
    _isLoadingStats = true;
    notifyListeners();

    try {
      final carId = _carProvider.selectedCarId ?? _carProvider.defaultCar?.id;
      _stats = await _api.getStatsForCar(carId);
      _error = null;
    } on Exception catch (e) {
      _log.error('Error refreshing stats', e);
    }

    _isLoadingStats = false;
    notifyListeners();
  }

  Future<void> refreshLocations() async {
    try {
      _locations = await _api.getLocations();
      _error = null;
    } on Exception catch (e) {
      _log.error('Error refreshing locations', e);
    }
    notifyListeners();
  }

  /// Refresh all trip-related data
  Future<void> refreshAll() async {
    await Future.wait([
      refreshActiveTrip(),
      refreshTrips(),
      refreshStats(),
      refreshLocations(),
    ]);
  }

  // ============ Trip CRUD Operations ============

  Future<bool> createTrip(Map<String, dynamic> tripData) async {
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

  // ============ Webhook Actions ============

  /// Start trip for a specific car with device ID
  Future<bool> startTripForCar(Car car, String deviceId) async {
    // Set Crashlytics context for trip debugging
    CrashlyticsLogger.setCarContext(car.id, car.brand);
    CrashlyticsLogger.log('Trip starting for car: ${car.name}');

    final location = await _location.getCurrentLocation();
    if (location == null) {
      _error = _location.lastError ?? 'Kon locatie niet bepalen';
      notifyListeners();
      return false;
    }

    if (!_connectivityProvider.isOnline) {
      await _connectivityProvider.addToQueue('start', location.lat, location.lng, deviceId: deviceId);
      await _background.startTrip();
      onTripStarted?.call();
      return true;
    }

    try {
      await _api.startTrip(location.lat, location.lng, deviceId: deviceId);
      await refreshActiveTrip();
      // Set active trip context for Crashlytics (use startTime as unique identifier)
      if (_activeTrip?.startTime != null) {
        CrashlyticsLogger.setTripContext(_activeTrip!.startTime!);
      }
      await _background.startTrip();
      await _background.notifyWatchTripStarted();
      // Show trip started notification
      unawaited(_notifications.showTripStartedNotification(car.name));
      // Log analytics event
      unawaited(AnalyticsService.logTripStarted(
        carId: car.id,
        carBrand: car.brand,
        method: 'bluetooth',
      ));
      onTripStarted?.call();
      return true;
    } on Exception {
      await _connectivityProvider.addToQueue('start', location.lat, location.lng, deviceId: deviceId);
      await _background.startTrip();
      // Show trip started notification even in offline mode
      unawaited(_notifications.showTripStartedNotification(car.name));
      // Log analytics event (even in offline mode)
      unawaited(AnalyticsService.logTripStarted(
        carId: car.id,
        carBrand: car.brand,
        method: 'bluetooth',
      ));
      onTripStarted?.call();
      return true;
    }
  }

  /// Manual start trip
  /// - For cars with API (audi, vw, tesla, etc.): uses motion detection, no Bluetooth needed
  /// - For cars without API: requires Bluetooth to identify which car
  Future<bool> startTrip() async {
    // Check if we have a selected car
    final car = _carProvider.selectedCar ?? _carProvider.defaultCar;

    if (car == null) {
      _error = 'Geen auto geselecteerd. Voeg eerst een auto toe.';
      notifyListeners();
      return false;
    }

    // Check if car has API support (known brand with potential API)
    final hasApiSupport = car.brand != 'other';

    // Try Bluetooth first (works for all cars)
    final deviceName = _connectivityProvider.connectedBluetoothDevice ??
        await _connectivityProvider.getConnectedDevice();

    if (deviceName != null) {
      // Bluetooth connected - find matching car or use current
      final matchedCar = _carProvider.findCarByDeviceId(deviceName);

      if (matchedCar != null) {
        return startTripForCar(matchedCar, deviceName);
      } else {
        // Unknown device - trigger linking flow
        _connectivityProvider.setPendingUnknownDevice(deviceName);
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
    // Clear Crashlytics trip context
    CrashlyticsLogger.clearTripContext();
    CrashlyticsLogger.log('Trip ended');

    final location = await _location.getCurrentLocation();
    if (location == null) {
      _error = _location.lastError ?? 'Kon locatie niet bepalen';
      notifyListeners();
      return false;
    }

    if (!_connectivityProvider.isOnline) {
      await _connectivityProvider.addToQueue('end', location.lat, location.lng);
      onTripEnded?.call();
      return true;
    }

    // Capture trip data before ending
    final tripDistance = _activeTrip?.distanceKm;
    final tripStartStr = _activeTrip?.startTime;
    final tripStart = tripStartStr != null ? DateTime.tryParse(tripStartStr) : null;
    final durationMinutes = tripStart != null
        ? DateTime.now().difference(tripStart).inMinutes
        : null;

    try {
      await _api.endTrip(location.lat, location.lng);
      await refreshActiveTrip();
      // Log analytics event
      unawaited(AnalyticsService.logTripEnded(
        distanceKm: tripDistance,
        durationMinutes: durationMinutes,
      ));
      onTripEnded?.call();
      return true;
    } on Exception catch (e) {
      _log.error('Error ending trip', e);
      await _connectivityProvider.addToQueue('end', location.lat, location.lng);
      // Log analytics event (even in offline mode)
      unawaited(AnalyticsService.logTripEnded(
        distanceKm: tripDistance,
        durationMinutes: durationMinutes,
      ));
      onTripEnded?.call();
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

    if (!_connectivityProvider.isOnline) {
      await _connectivityProvider.addToQueue('ping', location.lat, location.lng);
      return true;
    }

    try {
      await _api.sendPing(location.lat, location.lng);
      await refreshActiveTrip();
      return true;
    } on Exception catch (e) {
      _log.error('Error sending ping', e);
      await _connectivityProvider.addToQueue('ping', location.lat, location.lng);
      return true;
    }
  }

  Future<bool> finalizeTrip() async {
    _location.stopBackgroundTracking();
    CrashlyticsLogger.clearTripContext();
    CrashlyticsLogger.log('Trip finalized');
    try {
      await _api.finalize();
      await refreshActiveTrip();
      await refreshTrips();
      onTripEnded?.call();
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
    CrashlyticsLogger.clearTripContext();
    CrashlyticsLogger.log('Trip cancelled');
    try {
      await _api.cancel();
      await refreshActiveTrip();
      // Log analytics event
      unawaited(AnalyticsService.logTripCancelled(reason: 'user_cancelled'));
      onTripEnded?.call();
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
