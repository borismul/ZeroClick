// Settings state provider

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/logging/app_logger.dart';
import '../models/settings.dart';
import '../services/background_service.dart';
import '../services/debug_log_service.dart';

/// Provider for app settings persistence and access.
///
/// This is the foundation provider - other providers depend on settings
/// for API URLs and configuration.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    // Fire and forget - don't block constructor
    Future.microtask(loadSettings);
  }

  static const String _settingsKey = 'app_settings';
  static const _log = AppLogger('SettingsProvider');

  // State
  AppSettings _settings = AppSettings.defaults();

  // Completer that signals when initial load is done
  final Completer<void> _loadCompleter = Completer<void>();

  /// Future that completes when settings have been loaded from disk
  Future<void> get settingsLoaded => _loadCompleter.future;

  // Getters
  AppSettings get settings => _settings;
  bool get isConfigured => _settings.isConfigured;
  String get apiUrl => _settings.apiUrl;
  String get userEmail => _settings.userEmail;

  void _debug(String msg) => DebugLogService.instance.addLog('Settings', msg);

  /// Load settings from SharedPreferences
  Future<void> loadSettings() async {
    _debug('loadSettings: STARTING');
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_settingsKey);
      _debug('loadSettings: data=${data != null ? "exists" : "null"}');
      if (data != null) {
        _settings = AppSettings.fromJson(jsonDecode(data) as Map<String, dynamic>);
        _debug('loadSettings: email="${_settings.userEmail}", configured=${_settings.isConfigured}');
      } else {
        _debug('loadSettings: no saved settings');
      }
    } on Exception catch (e) {
      _debug('loadSettings: ERROR $e');
      _log.error('Error loading settings', e);
    }
    // Signal that initial load is complete
    _debug('loadSettings: completing');
    if (!_loadCompleter.isCompleted) {
      _loadCompleter.complete();
    }
    notifyListeners();
  }

  /// Save settings to SharedPreferences and sync to native
  Future<void> saveSettings(AppSettings newSettings) async {
    _settings = newSettings;

    // Send config to native for direct API calls
    unawaited(BackgroundService().setApiConfig(_settings.apiUrl, _settings.userEmail));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, jsonEncode(_settings.toJson()));
    } on Exception catch (e) {
      _log.error('Error saving settings', e);
    }
    notifyListeners();
  }
}
