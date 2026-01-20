import 'package:flutter/material.dart';
import '../core/error/error_handler.dart';

class ErrorProvider extends ChangeNotifier {
  ErrorInfo? _currentError;
  ErrorInfo? get currentError => _currentError;

  void showError(dynamic error, {VoidCallback? onRetry}) {
    _currentError = ErrorHandler.categorize(error, onRetry: onRetry);
    notifyListeners();
  }

  void clearError() {
    _currentError = null;
    notifyListeners();
  }

  /// Handle an error with logging and optional UI display
  Future<void> handleError(
    dynamic error,
    StackTrace? stack, {
    VoidCallback? onRetry,
    bool showDialog = true,
    bool fatal = false,
  }) async {
    // Log to Crashlytics
    ErrorHandler.logError(error, stack, fatal: fatal);

    // Show in UI if requested
    if (showDialog) {
      showError(error, onRetry: onRetry);
    }
  }
}
