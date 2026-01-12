import 'package:flutter/services.dart';

import '../core/logging/app_logger.dart';
import 'auth_service.dart';

typedef CarDetectedCallback = void Function(String deviceName, double lat, double lng);
typedef LocationUpdateCallback = void Function(double lat, double lng);
typedef TripEndedCallback = void Function(String status);

/// Service to handle background car detection via native iOS location monitoring
class BackgroundService {
  BackgroundService() {
    _setupMethodCallHandler();
  }

  static const _channel = MethodChannel('nl.borism.mileage/background');
  static const _log = AppLogger('BackgroundService');

  CarDetectedCallback? _onCarDetected;
  LocationUpdateCallback? _onLocationUpdate;
  TripEndedCallback? _onTripEnded;

  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onCarDetected':
          final args = call.arguments as Map<dynamic, dynamic>;
          final deviceName = args['deviceName'] as String;
          final lat = (args['latitude'] as num).toDouble();
          final lng = (args['longitude'] as num).toDouble();
          _log.info('Car detected: $deviceName at $lat, $lng');
          _onCarDetected?.call(deviceName, lat, lng);
        case 'onLocationUpdate':
          final args = call.arguments as Map<dynamic, dynamic>;
          final lat = (args['latitude'] as num).toDouble();
          final lng = (args['longitude'] as num).toDouble();
          _log.debug('Location update: $lat, $lng');
          _onLocationUpdate?.call(lat, lng);
        case 'onTripEnded':
          final args = call.arguments as Map<dynamic, dynamic>;
          final status = args['status'] as String;
          _log.info('Trip ended: $status');
          _onTripEnded?.call(status);
        case 'getAuthToken':
          // Watch is requesting a fresh auth token - actually refresh it
          _log.info('Watch requesting auth token - refreshing...');
          final token = await AuthService().refreshToken();
          _log.info('Token refresh result: ${token != null ? "success" : "failed"}');
          return token;
        default:
          _log.warning('Unknown method: ${call.method}');
      }
      return null;
    });
  }

  /// Set callback for when car is detected in background
  void setCarDetectedCallback(CarDetectedCallback callback) {
    _onCarDetected = callback;
  }

  /// Set callback for location updates during active tracking
  void setLocationUpdateCallback(LocationUpdateCallback callback) {
    _onLocationUpdate = callback;
  }

  /// Set callback for when trip ends
  void setTripEndedCallback(TripEndedCallback callback) {
    _onTripEnded = callback;
  }

  /// Start background location monitoring (for car detection)
  Future<bool> startMonitoring() async {
    try {
      final result = await _channel.invokeMethod<bool>('startBackgroundMonitoring');
      _log.info('Started monitoring: $result');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error starting monitoring', e);
      return false;
    }
  }

  /// Stop background location monitoring
  Future<bool> stopMonitoring() async {
    try {
      final result = await _channel.invokeMethod<bool>('stopBackgroundMonitoring');
      _log.info('Stopped monitoring: $result');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error stopping monitoring', e);
      return false;
    }
  }

  /// Check if monitoring is active
  Future<bool> isMonitoring() async {
    try {
      final result = await _channel.invokeMethod<bool>('isMonitoring');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error checking monitoring', e);
      return false;
    }
  }

  /// Set API config for native direct API calls (bypasses Flutter)
  Future<bool> setApiConfig(String baseUrl, String userEmail) async {
    try {
      final result = await _channel.invokeMethod<bool>('setApiConfig', {
        'baseUrl': baseUrl,
        'userEmail': userEmail,
      });
      _log.info('API config set: $baseUrl, $userEmail');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error setting API config', e);
      return false;
    }
  }

  /// Sync auth token to Watch via native WatchConnectivity
  Future<bool> setAuthToken(String token) async {
    try {
      final result = await _channel.invokeMethod<bool>('setAuthToken', {
        'token': token,
      });
      _log.info('Auth token synced to watch');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error syncing auth token', e);
      return false;
    }
  }

  /// Notify Watch that a trip has started
  Future<bool> notifyWatchTripStarted() async {
    try {
      final result = await _channel.invokeMethod<bool>('notifyWatchTripStarted');
      _log.info('Watch notified of trip start');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error notifying watch', e);
      return false;
    }
  }

  /// Start active trip tracking (continuous GPS with blue bar indicator)
  Future<bool> startActiveTracking() async {
    try {
      final result = await _channel.invokeMethod<bool>('startActiveTracking');
      _log.info('Started active tracking: $result');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error starting active tracking', e);
      return false;
    }
  }

  /// Stop active trip tracking (revert to passive monitoring)
  Future<bool> stopActiveTracking() async {
    try {
      final result = await _channel.invokeMethod<bool>('stopActiveTracking');
      _log.info('Stopped active tracking: $result');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error stopping active tracking', e);
      return false;
    }
  }

  /// Check if active tracking is running
  Future<bool> isActivelyTracking() async {
    try {
      final result = await _channel.invokeMethod<bool>('isActivelyTracking');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error checking active tracking', e);
      return false;
    }
  }

  /// Set active car ID for native API calls (from Bluetooth detection)
  Future<bool> setActiveCarId(String? carId) async {
    try {
      final result = await _channel.invokeMethod<bool>('setActiveCarId', {
        'carId': carId,
      });
      _log.info('Active car ID set: $carId');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error setting active car ID', e);
      return false;
    }
  }

  /// Clear active car ID (when Bluetooth disconnects)
  Future<bool> clearActiveCarId() => setActiveCarId(null);

  /// Start trip tracking + Live Activity
  Future<bool> startTrip() async {
    try {
      final result = await _channel.invokeMethod<bool>('startTrip');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error starting trip', e);
      return false;
    }
  }

  /// End trip tracking + Live Activity
  Future<bool> endTrip() async {
    try {
      final result = await _channel.invokeMethod<bool>('endTrip');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error ending trip', e);
      return false;
    }
  }
}
