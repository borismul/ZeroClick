// CarPlay detection service

import 'package:flutter/services.dart';

import '../core/logging/app_logger.dart';

typedef CarPlayCallback = void Function({required bool connected});

class CarPlayService {
  CarPlayService() {
    _setupMethodCallHandler();
  }

  static const _channel = MethodChannel('com.zeroclick/carplay');
  static const _log = AppLogger('CarPlayService');

  CarPlayCallback? _onConnectionChanged;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onCarPlayConnected':
          _isConnected = true;
          _log.info('Connected!');
          _onConnectionChanged?.call(connected: true);
        case 'onCarPlayDisconnected':
          _isConnected = false;
          _log.info('Disconnected!');
          _onConnectionChanged?.call(connected: false);
      }
      return null;
    });
  }

  /// Set callback for CarPlay connection changes
  void setConnectionCallback(CarPlayCallback callback) {
    _onConnectionChanged = callback;
  }

  /// Check if CarPlay is currently connected
  Future<bool> checkConnection() async {
    try {
      final result = await _channel.invokeMethod<bool>('isCarPlayConnected');
      _isConnected = result ?? false;
      return _isConnected;
    } on PlatformException catch (e) {
      _log.error('Error checking connection', e);
      return false;
    }
  }

  void dispose() {
    _onConnectionChanged = null;
  }
}
