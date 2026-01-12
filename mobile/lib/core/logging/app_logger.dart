import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Log level enumeration
enum LogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3),
  none(99);

  const LogLevel(this.value);
  final int value;
}

/// Application logger that replaces print statements
///
/// Uses dart:developer log in debug mode for better DevTools integration.
/// Provides structured logging with levels and tags.
class AppLogger {
  /// Create a logger with a specific tag
  const AppLogger(this.tag);

  /// The tag/category for this logger
  final String tag;

  /// Global minimum log level
  static LogLevel minimumLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;

  /// Log a debug message (development only)
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  /// Log an info message
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  /// Log a warning message
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  /// Log an error message
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  void _log(LogLevel level, String message, Object? error, StackTrace? stackTrace) {
    if (level.value < minimumLevel.value) return;

    if (kDebugMode) {
      developer.log(
        message,
        name: tag,
        level: _toDeveloperLevel(level),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  int _toDeveloperLevel(LogLevel level) => switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
        LogLevel.none => 0,
      };
}

/// Global logger for quick access
const log = AppLogger('App');
