import 'package:flutter/services.dart';

typedef CarDetectedCallback = void Function(String deviceName, double lat, double lng);
typedef LocationUpdateCallback = void Function(double lat, double lng);
typedef TripEndedCallback = void Function(String status);

/// Service to handle background car detection via native iOS location monitoring
class BackgroundService {
  static const _channel = MethodChannel('nl.borism.mileage/background');

  CarDetectedCallback? _onCarDetected;
  LocationUpdateCallback? _onLocationUpdate;
  TripEndedCallback? _onTripEnded;

  BackgroundService() {
    _setupMethodCallHandler();
  }

  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onCarDetected':
          final args = call.arguments as Map<dynamic, dynamic>;
          final deviceName = args['deviceName'] as String;
          final lat = (args['latitude'] as num).toDouble();
          final lng = (args['longitude'] as num).toDouble();
          print('[BackgroundService] Car detected: $deviceName at $lat, $lng');
          _onCarDetected?.call(deviceName, lat, lng);
          break;
        case 'onLocationUpdate':
          final args = call.arguments as Map<dynamic, dynamic>;
          final lat = (args['latitude'] as num).toDouble();
          final lng = (args['longitude'] as num).toDouble();
          print('[BackgroundService] Location update: $lat, $lng');
          _onLocationUpdate?.call(lat, lng);
          break;
        case 'onTripEnded':
          final args = call.arguments as Map<dynamic, dynamic>;
          final status = args['status'] as String;
          print('[BackgroundService] Trip ended: $status');
          _onTripEnded?.call(status);
          break;
        default:
          print('[BackgroundService] Unknown method: ${call.method}');
      }
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
      final result = await _channel.invokeMethod('startBackgroundMonitoring');
      print('[BackgroundService] Started monitoring: $result');
      return result == true;
    } catch (e) {
      print('[BackgroundService] Error starting monitoring: $e');
      return false;
    }
  }

  /// Stop background location monitoring
  Future<bool> stopMonitoring() async {
    try {
      final result = await _channel.invokeMethod('stopBackgroundMonitoring');
      print('[BackgroundService] Stopped monitoring: $result');
      return result == true;
    } catch (e) {
      print('[BackgroundService] Error stopping monitoring: $e');
      return false;
    }
  }

  /// Check if monitoring is active
  Future<bool> isMonitoring() async {
    try {
      final result = await _channel.invokeMethod('isMonitoring');
      return result == true;
    } catch (e) {
      print('[BackgroundService] Error checking monitoring: $e');
      return false;
    }
  }

  /// Set API config for native direct API calls (bypasses Flutter)
  Future<bool> setApiConfig(String baseUrl, String userEmail) async {
    try {
      final result = await _channel.invokeMethod('setApiConfig', {
        'baseUrl': baseUrl,
        'userEmail': userEmail,
      });
      print('[BackgroundService] API config set: $baseUrl, $userEmail');
      return result == true;
    } catch (e) {
      print('[BackgroundService] Error setting API config: $e');
      return false;
    }
  }

  /// Start active trip tracking (continuous GPS with blue bar indicator)
  Future<bool> startActiveTracking() async {
    try {
      final result = await _channel.invokeMethod('startActiveTracking');
      print('[BackgroundService] Started active tracking: $result');
      return result == true;
    } catch (e) {
      print('[BackgroundService] Error starting active tracking: $e');
      return false;
    }
  }

  /// Stop active trip tracking (revert to passive monitoring)
  Future<bool> stopActiveTracking() async {
    try {
      final result = await _channel.invokeMethod('stopActiveTracking');
      print('[BackgroundService] Stopped active tracking: $result');
      return result == true;
    } catch (e) {
      print('[BackgroundService] Error stopping active tracking: $e');
      return false;
    }
  }

  /// Check if active tracking is running
  Future<bool> isActivelyTracking() async {
    try {
      final result = await _channel.invokeMethod('isActivelyTracking');
      return result == true;
    } catch (e) {
      print('[BackgroundService] Error checking active tracking: $e');
      return false;
    }
  }
}
