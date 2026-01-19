import 'package:zero_click/services/background_service.dart';

/// Fake Background service for testing native iOS integration.
///
/// Since BackgroundService uses MethodChannel directly without an abstract
/// interface, this fake implements the same public API for testing.
///
/// Usage:
/// ```dart
/// final fakeBackground = FakeBackgroundService();
/// fakeBackground.setCarDetectedCallback((device, lat, lng) {
///   // Handle car detection in test
/// });
/// // Simulate native car detection
/// fakeBackground.simulateCarDetected('Audi MMI', 51.9270, 4.3620);
/// ```
class FakeBackgroundService {
  bool _isMonitoring = false;
  bool _isActivelyTracking = false;
  String? _apiBaseUrl;
  String? _userEmail;
  String? _authToken;
  String? _activeCarId;

  CarDetectedCallback? _carDetectedCallback;
  LocationUpdateCallback? _locationUpdateCallback;
  TripEndedCallback? _tripEndedCallback;

  // === Test Setup Methods ===

  /// Simulate car being detected (triggers trip start flow)
  void simulateCarDetected(String deviceName, double lat, double lng) {
    _carDetectedCallback?.call(deviceName, lat, lng);
  }

  /// Simulate location update from native
  void simulateLocationUpdate(double lat, double lng) {
    _locationUpdateCallback?.call(lat, lng);
  }

  /// Simulate trip ended from native
  void simulateTripEnded(String status) {
    _tripEndedCallback?.call(status);
  }

  /// Reset state between tests
  void reset() {
    _isMonitoring = false;
    _isActivelyTracking = false;
    _apiBaseUrl = null;
    _userEmail = null;
    _authToken = null;
    _activeCarId = null;
    _carDetectedCallback = null;
    _locationUpdateCallback = null;
    _tripEndedCallback = null;
  }

  // === Getters for test verification ===

  /// Get the configured API base URL
  String? get configuredBaseUrl => _apiBaseUrl;

  /// Get the configured user email
  String? get configuredEmail => _userEmail;

  /// Get the configured auth token
  String? get configuredToken => _authToken;

  /// Get the configured car ID
  String? get configuredCarId => _activeCarId;

  // === BackgroundService API ===

  /// Set callback for when car is detected in background
  void setCarDetectedCallback(CarDetectedCallback callback) {
    _carDetectedCallback = callback;
  }

  /// Set callback for location updates during active tracking
  void setLocationUpdateCallback(LocationUpdateCallback callback) {
    _locationUpdateCallback = callback;
  }

  /// Set callback for when trip ends
  void setTripEndedCallback(TripEndedCallback callback) {
    _tripEndedCallback = callback;
  }

  /// Start background location monitoring (for car detection)
  Future<bool> startMonitoring() async {
    _isMonitoring = true;
    return true;
  }

  /// Stop background location monitoring
  Future<bool> stopMonitoring() async {
    _isMonitoring = false;
    return true;
  }

  /// Check if monitoring is active
  Future<bool> isMonitoring() async => _isMonitoring;

  /// Set API config for native direct API calls (bypasses Flutter)
  Future<bool> setApiConfig(String baseUrl, String userEmail) async {
    _apiBaseUrl = baseUrl;
    _userEmail = userEmail;
    return true;
  }

  /// Sync auth token to Watch via native WatchConnectivity
  Future<bool> setAuthToken(String token) async {
    _authToken = token;
    return true;
  }

  /// Set active car ID for native API calls (from Bluetooth detection)
  Future<bool> setActiveCarId(String? carId) async {
    _activeCarId = carId;
    return true;
  }

  /// Clear active car ID (when Bluetooth disconnects)
  Future<bool> clearActiveCarId() async {
    _activeCarId = null;
    return true;
  }

  /// Notify Watch that a trip has started
  Future<bool> notifyWatchTripStarted() async => true;

  /// Start active trip tracking (continuous GPS with blue bar indicator)
  Future<bool> startActiveTracking() async {
    _isActivelyTracking = true;
    return true;
  }

  /// Stop active trip tracking (revert to passive monitoring)
  Future<bool> stopActiveTracking() async {
    _isActivelyTracking = false;
    return true;
  }

  /// Check if active tracking is running
  Future<bool> isActivelyTracking() async => _isActivelyTracking;

  /// Start trip tracking + Live Activity
  Future<bool> startTrip() async => true;

  /// End trip tracking + Live Activity
  Future<bool> endTrip() async => true;
}
