import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Wrapper for Firebase Crashlytics logging.
///
/// Provides static methods for:
/// - User identification
/// - Custom keys for debugging context
/// - Log messages
/// - Non-fatal error recording
class CrashlyticsLogger {
  CrashlyticsLogger._();

  static FirebaseCrashlytics get _instance => FirebaseCrashlytics.instance;

  /// Set the user identifier for crash reports.
  static void setUserIdentifier(String userId) {
    _instance.setUserIdentifier(userId);
  }

  /// Set a custom key-value pair for crash context.
  static void setCustomKey(String key, Object value) {
    _instance.setCustomKey(key, value);
  }

  /// Log a message that will be included in crash reports.
  static void log(String message) {
    _instance.log(message);
  }

  /// Record a non-fatal error with optional stack trace and reason.
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    await _instance.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  /// Clear the active trip context.
  static void clearTripContext() {
    _instance.setCustomKey('active_trip_id', '');
  }

  /// Set trip context for crash debugging.
  static void setTripContext(String tripId) {
    _instance.setCustomKey('active_trip_id', tripId);
    _instance.log('Trip started: $tripId');
  }

  /// Set car context for crash debugging.
  static void setCarContext(String carId, String carBrand) {
    _instance.setCustomKey('selected_car_id', carId);
    _instance.setCustomKey('car_brand', carBrand);
  }
}
