// Bluetooth device detection service

import 'package:flutter/services.dart';

typedef BluetoothCallback = void Function(String? deviceName);

class BluetoothService {
  static const _channel = MethodChannel('nl.borism.mileage/bluetooth');

  BluetoothCallback? _onConnectionChanged;
  String? _connectedDevice;

  String? get connectedDevice => _connectedDevice;
  bool get isConnected => _connectedDevice != null;

  BluetoothService() {
    _setupMethodCallHandler();
  }

  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onBluetoothConnected':
          final args = call.arguments as Map<dynamic, dynamic>?;
          _connectedDevice = args?['deviceName'] as String?;
          print('[Bluetooth] Connected: $_connectedDevice');
          _onConnectionChanged?.call(_connectedDevice);
          break;
        case 'onBluetoothDisconnected':
          _connectedDevice = null;
          print('[Bluetooth] Disconnected');
          _onConnectionChanged?.call(null);
          break;
      }
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
    } catch (e) {
      print('[Bluetooth] Error getting device: $e');
      return null;
    }
  }

  /// Check if Bluetooth is currently connected
  Future<bool> checkConnection() async {
    try {
      final result = await _channel.invokeMethod<bool>('isBluetoothConnected');
      return result ?? false;
    } catch (e) {
      print('[Bluetooth] Error checking connection: $e');
      return false;
    }
  }

  void dispose() {
    _onConnectionChanged = null;
  }
}
