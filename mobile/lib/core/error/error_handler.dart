import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../api/api_exception.dart';
import '../logging/app_logger.dart';

enum ErrorSeverity { info, warning, error, fatal }

class ErrorInfo {
  final String title;
  final String message;
  final ErrorSeverity severity;
  final bool canRetry;
  final VoidCallback? onRetry;

  ErrorInfo({
    required this.title,
    required this.message,
    this.severity = ErrorSeverity.error,
    this.canRetry = false,
    this.onRetry,
  });
}

class ErrorHandler {
  static const _logger = AppLogger('ErrorHandler');

  static ErrorInfo categorize(dynamic error, {VoidCallback? onRetry}) {
    // Network errors - can retry
    if (error is NetworkException) {
      return ErrorInfo(
        title: 'Geen verbinding',
        message: 'Controleer je internetverbinding en probeer opnieuw.',
        severity: ErrorSeverity.warning,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Auth errors - need re-login
    if (error is UnauthorizedException) {
      return ErrorInfo(
        title: 'Sessie verlopen',
        message: 'Log opnieuw in om door te gaan.',
        severity: ErrorSeverity.warning,
        canRetry: false,
      );
    }

    // Server errors - can retry
    if (error is ServerException) {
      return ErrorInfo(
        title: 'Serverfout',
        message: 'Er is iets misgegaan. Probeer het later opnieuw.',
        severity: ErrorSeverity.error,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Validation errors - user needs to fix input
    if (error is ValidationException) {
      return ErrorInfo(
        title: 'Ongeldige invoer',
        message: error.message,
        severity: ErrorSeverity.info,
        canRetry: false,
      );
    }

    // Timeout - can retry
    if (error is TimeoutException) {
      return ErrorInfo(
        title: 'Timeout',
        message: 'De server reageert niet. Probeer opnieuw.',
        severity: ErrorSeverity.warning,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Unknown error
    return ErrorInfo(
      title: 'Fout',
      message: 'Er is een onverwachte fout opgetreden.',
      severity: ErrorSeverity.error,
      canRetry: true,
      onRetry: onRetry,
    );
  }

  static void logError(dynamic error, StackTrace? stack, {bool fatal = false}) {
    _logger.error('Error occurred', error, stack);
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
  }
}
