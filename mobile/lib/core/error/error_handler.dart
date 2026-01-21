import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  /// Categorize an error and return localized ErrorInfo
  /// Use this when you have a BuildContext available
  static ErrorInfo categorizeLocalized(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    final l10n = AppLocalizations.of(context)!;

    // Network errors - can retry
    if (error is NetworkException) {
      return ErrorInfo(
        title: l10n.noConnection,
        message: l10n.checkInternetConnection,
        severity: ErrorSeverity.warning,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Auth errors - need re-login
    if (error is UnauthorizedException) {
      return ErrorInfo(
        title: l10n.sessionExpired,
        message: l10n.loginAgainToContinue,
        severity: ErrorSeverity.warning,
        canRetry: false,
      );
    }

    // Server errors - can retry
    if (error is ServerException) {
      return ErrorInfo(
        title: l10n.serverError,
        message: l10n.tryAgainLater,
        severity: ErrorSeverity.error,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Validation errors - user needs to fix input
    if (error is ValidationException) {
      return ErrorInfo(
        title: l10n.invalidInput,
        message: error.message,
        severity: ErrorSeverity.info,
        canRetry: false,
      );
    }

    // Timeout - can retry
    if (error is TimeoutException) {
      return ErrorInfo(
        title: l10n.timeout,
        message: l10n.serverNotResponding,
        severity: ErrorSeverity.warning,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Unknown error
    return ErrorInfo(
      title: l10n.error,
      message: l10n.unexpectedError,
      severity: ErrorSeverity.error,
      canRetry: true,
      onRetry: onRetry,
    );
  }

  /// Legacy method - use categorizeLocalized when context is available
  @Deprecated('Use categorizeLocalized instead')
  static ErrorInfo categorize(dynamic error, {VoidCallback? onRetry}) {
    // Network errors - can retry
    if (error is NetworkException) {
      return ErrorInfo(
        title: 'No connection',
        message: 'Check your internet connection and try again.',
        severity: ErrorSeverity.warning,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Auth errors - need re-login
    if (error is UnauthorizedException) {
      return ErrorInfo(
        title: 'Session expired',
        message: 'Log in again to continue.',
        severity: ErrorSeverity.warning,
        canRetry: false,
      );
    }

    // Server errors - can retry
    if (error is ServerException) {
      return ErrorInfo(
        title: 'Server error',
        message: 'Something went wrong. Please try again later.',
        severity: ErrorSeverity.error,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Validation errors - user needs to fix input
    if (error is ValidationException) {
      return ErrorInfo(
        title: 'Invalid input',
        message: error.message,
        severity: ErrorSeverity.info,
        canRetry: false,
      );
    }

    // Timeout - can retry
    if (error is TimeoutException) {
      return ErrorInfo(
        title: 'Timeout',
        message: 'The server is not responding. Please try again.',
        severity: ErrorSeverity.warning,
        canRetry: true,
        onRetry: onRetry,
      );
    }

    // Unknown error
    return ErrorInfo(
      title: 'Error',
      message: 'An unexpected error occurred.',
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
