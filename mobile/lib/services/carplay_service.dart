// CarPlay detection service

import 'package:flutter/services.dart';

typedef CarPlayCallback = void Function(bool connected);

class CarPlayService {
  static const _channel = MethodChannel('nl.borism.mileage/carplay');

  CarPlayCallback? _onConnectionChanged;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  CarPlayService() {
    _setupMethodCallHandler();
  }

  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onCarPlayConnected':
          _isConnected = true;
          print('[CarPlay] Connected!');
          _onConnectionChanged?.call(true);
          break;
        case 'onCarPlayDisconnected':
          _isConnected = false;
          print('[CarPlay] Disconnected!');
          _onConnectionChanged?.call(false);
          break;
      }
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
    } catch (e) {
      print('[CarPlay] Error checking connection: $e');
      return false;
    }
  }

  void dispose() {
    _onConnectionChanged = null;
  }
}
