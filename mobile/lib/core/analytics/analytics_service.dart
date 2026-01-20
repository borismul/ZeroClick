import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Wrapper for Firebase Analytics with static methods.
/// Safe to call before Firebase is initialized - calls are no-ops until ready.
class AnalyticsService {
  AnalyticsService._();

  static FirebaseAnalytics? _instance;
  static FirebaseAnalytics? get _analytics {
    if (_instance != null) return _instance;
    try {
      if (Firebase.apps.isNotEmpty) {
        _instance = FirebaseAnalytics.instance;
      }
    } catch (_) {}
    return _instance;
  }

  static bool _initialized = false;
  static const _anonymousIdKey = 'analytics_anonymous_id';

  /// Initialize analytics settings and set anonymous user ID.
  /// Call once at app startup.
  static Future<void> init() async {
    if (_initialized) return;
    final analytics = _analytics;
    if (analytics == null) return;

    // Disable analytics collection in debug mode
    if (kDebugMode) {
      await analytics.setAnalyticsCollectionEnabled(false);
    } else {
      // Generate or retrieve anonymous user ID
      final prefs = await SharedPreferences.getInstance();
      var anonymousId = prefs.getString(_anonymousIdKey);
      if (anonymousId == null) {
        anonymousId = const Uuid().v4();
        await prefs.setString(_anonymousIdKey, anonymousId);
      }
      // Set anonymous ID until user logs in
      await analytics.setUserId(id: anonymousId);
    }

    _initialized = true;
  }

  /// Set user ID based on email (hashed for privacy).
  /// Call when user logs in to get consistent ID across reinstalls.
  static Future<void> setLoggedInUser(String email) async {
    if (kDebugMode) return;
    final analytics = _analytics;
    if (analytics == null) return;

    // Store anonymous ID as property to link pre-login events
    final prefs = await SharedPreferences.getInstance();
    final anonymousId = prefs.getString(_anonymousIdKey);
    if (anonymousId != null) {
      await analytics.setUserProperty(name: 'anonymous_id', value: anonymousId);
    }

    // Switch to email-based ID for cross-device/reinstall consistency
    final hashedEmail = sha256.convert(utf8.encode(email)).toString();
    await analytics.setUserId(id: hashedEmail);
  }

  /// Clear user ID (revert to anonymous).
  static Future<void> clearUser() async {
    if (kDebugMode) return;
    final analytics = _analytics;
    if (analytics == null) return;
    final prefs = await SharedPreferences.getInstance();
    final anonymousId = prefs.getString(_anonymousIdKey);
    await analytics.setUserId(id: anonymousId);
  }

  // ============ Core Methods ============

  /// Log a custom event with optional parameters.
  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (kDebugMode) return;
    final analytics = _analytics;
    if (analytics == null) return;
    await analytics.logEvent(name: name, parameters: parameters);
  }

  /// Log a screen view.
  static Future<void> logScreenView(String screenName) async {
    if (kDebugMode) return;
    final analytics = _analytics;
    if (analytics == null) return;
    await analytics.logScreenView(screenName: screenName);
  }

  /// Set a user property.
  static Future<void> setUserProperty(String name, String? value) async {
    if (kDebugMode) return;
    final analytics = _analytics;
    if (analytics == null) return;
    await analytics.setUserProperty(name: name, value: value);
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
