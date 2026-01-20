import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Wrapper for Firebase Analytics with static methods.
///
/// Provides static methods for:
/// - Event logging (custom events)
/// - Screen tracking
/// - User properties
/// - User identification
/// - Trip-specific convenience methods
///
/// Analytics collection is disabled in debug mode to avoid
/// polluting analytics with development data.
class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _instance = FirebaseAnalytics.instance;

  static bool _initialized = false;

  /// Initialize analytics settings.
  /// Call once at app startup.
  static Future<void> init() async {
    if (_initialized) return;

    // Disable analytics collection in debug mode
    if (kDebugMode) {
      await _instance.setAnalyticsCollectionEnabled(false);
    }

    _initialized = true;
  }

  // ============ Core Methods ============

  /// Log a custom event with optional parameters.
  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (kDebugMode) return;
    await _instance.logEvent(name: name, parameters: parameters);
  }

  /// Log a screen view.
  static Future<void> logScreenView(String screenName) async {
    if (kDebugMode) return;
    await _instance.logScreenView(screenName: screenName);
  }

  /// Set a user property.
  static Future<void> setUserProperty(String name, String? value) async {
    if (kDebugMode) return;
    await _instance.setUserProperty(name: name, value: value);
  }

  /// Set the user ID (should be hashed, not raw PII).
  static Future<void> setUserId(String? id) async {
    if (kDebugMode) return;
    await _instance.setUserId(id: id);
  }

  // ============ Trip Event Methods ============

  /// Log trip started event.
  ///
  /// [carId] - The car identifier
  /// [carBrand] - The car brand (audi, tesla, etc.)
  /// [method] - Detection method: 'bluetooth', 'motion', or 'api'
  static Future<void> logTripStarted({
    String? carId,
    String? carBrand,
    String? method,
  }) async {
    await logEvent('trip_started', parameters: {
      if (carId != null) 'car_id': carId,
      if (carBrand != null) 'car_brand': carBrand,
      if (method != null) 'detection_method': method,
    });
  }

  /// Log trip ended event.
  ///
  /// [distanceKm] - Trip distance in kilometers
  /// [durationMinutes] - Trip duration in minutes
  /// [classification] - Trip classification (business, private, mixed)
  static Future<void> logTripEnded({
    double? distanceKm,
    int? durationMinutes,
    String? classification,
  }) async {
    await logEvent('trip_ended', parameters: {
      if (distanceKm != null) 'distance_km': distanceKm,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (classification != null) 'classification': classification,
    });
  }

  /// Log trip cancelled event.
  ///
  /// [reason] - Cancellation reason (user_cancelled, no_car_found, etc.)
  static Future<void> logTripCancelled({String? reason}) async {
    await logEvent('trip_cancelled', parameters: {
      if (reason != null) 'reason': reason,
    });
  }
}
