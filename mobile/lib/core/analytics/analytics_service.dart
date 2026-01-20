import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Wrapper for Firebase Analytics with static methods.
///
/// Provides static methods for:
/// - Event logging (custom events)
/// - Screen tracking
/// - User properties
/// - User identification
/// - Trip-specific convenience methods
///
/// User ID Strategy:
/// - Anonymous users: random UUID (persisted locally)
/// - Logged-in users: SHA256 hash of email (consistent across reinstalls)
///
/// Analytics collection is disabled in debug mode to avoid
/// polluting analytics with development data.
class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _instance = FirebaseAnalytics.instance;

  static bool _initialized = false;
  static const _anonymousIdKey = 'analytics_anonymous_id';

  /// Initialize analytics settings and set anonymous user ID.
  /// Call once at app startup.
  static Future<void> init() async {
    if (_initialized) return;

    // Disable analytics collection in debug mode
    if (kDebugMode) {
      await _instance.setAnalyticsCollectionEnabled(false);
    } else {
      // Generate or retrieve anonymous user ID
      final prefs = await SharedPreferences.getInstance();
      var anonymousId = prefs.getString(_anonymousIdKey);
      if (anonymousId == null) {
        anonymousId = const Uuid().v4();
        await prefs.setString(_anonymousIdKey, anonymousId);
      }
      // Set anonymous ID until user logs in
      await _instance.setUserId(id: anonymousId);
    }

    _initialized = true;
  }

  /// Set user ID based on email (hashed for privacy).
  /// Call when user logs in to get consistent ID across reinstalls.
  static Future<void> setLoggedInUser(String email) async {
    if (kDebugMode) return;
    final hashedEmail = sha256.convert(utf8.encode(email)).toString();
    await _instance.setUserId(id: hashedEmail);
  }

  /// Clear user ID (revert to anonymous).
  /// Call when user logs out.
  static Future<void> clearUser() async {
    if (kDebugMode) return;
    final prefs = await SharedPreferences.getInstance();
    final anonymousId = prefs.getString(_anonymousIdKey);
    await _instance.setUserId(id: anonymousId);
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
