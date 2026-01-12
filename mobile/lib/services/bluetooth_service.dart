// Bluetooth device detection service

import 'package:flutter/services.dart';

import '../core/logging/app_logger.dart';

typedef BluetoothCallback = void Function(String? deviceName);

class BluetoothService {
  BluetoothService() {
    _setupMethodCallHandler();
  }

  static const _channel = MethodChannel('nl.borism.mileage/bluetooth');
  static const _log = AppLogger('BluetoothService');

  BluetoothCallback? _onConnectionChanged;
  String? _connectedDevice;

  String? get connectedDevice => _connectedDevice;
  bool get isConnected => _connectedDevice != null;

  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onBluetoothConnected':
          final args = call.arguments as Map<dynamic, dynamic>?;
          _connectedDevice = args?['deviceName'] as String?;
          _log.info('Connected: $_connectedDevice');
          _onConnectionChanged?.call(_connectedDevice);
        case 'onBluetoothDisconnected':
          _connectedDevice = null;
          _log.info('Disconnected');
          _onConnectionChanged?.call(null);
      }
      return null;
    });
  }

  /// Set callback for Bluetooth connection changes
  void setConnectionCallback(BluetoothCallback callback) {
    _onConnectionChanged = callback;
  }

  /// Get currently connected Bluetooth device name
  Future<String?> getConnectedDevice() async {
    try {
      final result = await _channel.invokeMethod<String>('getConnectedDevice');
      _connectedDevice = result;
      return result;
    } on MissingPluginException {
      // Native side not implemented - that's OK
      _log.debug('Bluetooth channel not implemented on this platform');
      return null;
    } on PlatformException catch (e) {
      _log.error('Error getting device', e);
      return null;
    }
  }

  /// Check if Bluetooth is currently connected
  Future<bool> checkConnection() async {
    try {
      final result = await _channel.invokeMethod<bool>('isBluetoothConnected');
      return result ?? false;
    } on PlatformException catch (e) {
      _log.error('Error checking connection', e);
      return false;
    }
  }

  void dispose() {
    _onConnectionChanged = null;
  }
}
