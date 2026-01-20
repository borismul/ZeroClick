import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

/// Wrapper for Firebase Crashlytics logging.
/// Safe to call before Firebase is initialized - calls are no-ops until ready.
class CrashlyticsLogger {
  CrashlyticsLogger._();

  static bool get _isReady {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static FirebaseCrashlytics get _instance => FirebaseCrashlytics.instance;

  static void setUserIdentifier(String userId) {
    if (!_isReady) return;
    _instance.setUserIdentifier(userId);
  }

  static void setCustomKey(String key, Object value) {
    if (!_isReady) return;
    _instance.setCustomKey(key, value);
  }

  static void log(String message) {
    if (!_isReady) return;
    _instance.log(message);
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!_isReady) return;
    await _instance.recordError(exception, stack, reason: reason, fatal: fatal);
  }

  static void clearTripContext() {
    if (!_isReady) return;
    _instance.setCustomKey('active_trip_id', '');
  }

  static void setTripContext(String tripId) {
    if (!_isReady) return;
    _instance.setCustomKey('active_trip_id', tripId);
    _instance.log('Trip started: $tripId');
  }

  static void setCarContext(String carId, String carBrand) {
    if (!_isReady) return;
    _instance.setCustomKey('selected_car_id', carId);
    _instance.setCustomKey('car_brand', carBrand);
  }
}
