import 'package:zero_click/services/location_service.dart';

/// Fake location service for testing - allows scheduling GPS locations
/// and triggering pings manually for drive simulation.
class FakeLocationService implements LocationServiceInterface {
  final List<LocationResult> _scheduledLocations = [];
  void Function(LocationResult)? _onLocationUpdate;
  bool _isTracking = false;
  int _currentIndex = 0;
  String? _lastError;
  bool _hasPermission = true;
  bool _locationEnabled = true;

  // === Test Setup Methods ===

  /// Queue a sequence of locations for a simulated drive
  void scheduleDrive(List<LocationResult> locations) {
    _scheduledLocations.addAll(locations);
  }

  /// Clear scheduled locations and reset state
  void reset() {
    _scheduledLocations.clear();
    _currentIndex = 0;
    _isTracking = false;
    _onLocationUpdate = null;
    _lastError = null;
  }

  /// Simulate the next ping being triggered (called by test/FakeAsync)
  void triggerNextPing() {
    if (_currentIndex < _scheduledLocations.length && _onLocationUpdate != null) {
      _onLocationUpdate!(_scheduledLocations[_currentIndex++]);
    }
  }

  /// Set whether permissions are granted (for permission testing)
  void setHasPermission(bool value) => _hasPermission = value;

  /// Set whether location services are enabled
  void setLocationEnabled(bool value) => _locationEnabled = value;

  /// Simulate an error occurring
  void simulateError(String error) => _lastError = error;

  // === LocationServiceInterface Implementation ===

  @override
  Future<bool> requestPermissions() async => _hasPermission;

  @override
  Future<bool> get hasPermission async => _hasPermission;

  @override
  Future<LocationResult?> getCurrentLocation() async {
    if (_currentIndex < _scheduledLocations.length) {
      return _scheduledLocations[_currentIndex];
    }
    return null;
  }

  @override
  Future<LocationResult?> getLastKnownLocation() async {
    if (_currentIndex > 0 && _currentIndex <= _scheduledLocations.length) {
      return _scheduledLocations[_currentIndex - 1];
    }
    return null;
  }

  @override
  Future<bool> isLocationEnabled() async => _locationEnabled;

  @override
  Future<bool> startBackgroundTracking({
    required void Function(LocationResult) onLocationUpdate,
    Duration pingInterval = const Duration(minutes: 1),
  }) async {
    _onLocationUpdate = onLocationUpdate;
    _isTracking = true;
    return true;
  }

  @override
  void stopBackgroundTracking() {
    _isTracking = false;
    _onLocationUpdate = null;
  }

  @override
  bool get isTracking => _isTracking;

  @override
  String? get lastError => _lastError;
}
