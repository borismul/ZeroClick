// Settings state provider

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/logging/app_logger.dart';
import '../models/settings.dart';
import '../services/background_service.dart';

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

  // Getters
  AppSettings get settings => _settings;
  bool get isConfigured => _settings.isConfigured;
  String get apiUrl => _settings.apiUrl;
  String get userEmail => _settings.userEmail;

  /// Load settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_settingsKey);
      if (data != null) {
        _settings = AppSettings.fromJson(jsonDecode(data) as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      _log.error('Error loading settings', e);
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
