import 'package:zero_click/services/bluetooth_service.dart';

/// Fake Bluetooth service for testing car detection without real Bluetooth.
///
/// Since BluetoothService doesn't have an abstract interface (it uses
/// MethodChannel directly), this fake implements the same public API
/// for use in tests.
///
/// Usage:
/// ```dart
/// final fakeBluetooth = FakeBluetoothService();
/// // Simulate connecting to car Bluetooth
/// fakeBluetooth.simulateConnect('Audi MMI 1234');
/// // Verify app behavior
/// expect(fakeBluetooth.connectedDevice, equals('Audi MMI 1234'));
/// ```
class FakeBluetoothService {
  String? _connectedDevice;
  BluetoothCallback? _callback;

  // === Test Setup Methods ===

  /// Simulate connecting to a Bluetooth device
  void simulateConnect(String deviceName) {
    _connectedDevice = deviceName;
    _callback?.call(deviceName);
  }

  /// Simulate disconnecting from Bluetooth
  void simulateDisconnect() {
    _connectedDevice = null;
    _callback?.call(null);
  }

  /// Reset state between tests
  void reset() {
    _connectedDevice = null;
    _callback = null;
  }

  // === BluetoothService API ===

  /// Get currently connected Bluetooth device name
  Future<String?> getConnectedDevice() async => _connectedDevice;

  /// Check if Bluetooth is currently connected
  Future<bool> checkConnection() async => _connectedDevice != null;

  /// Set callback for Bluetooth connection changes
  void setConnectionCallback(BluetoothCallback callback) {
    _callback = callback;
  }

  /// Get the currently connected device name
  String? get connectedDevice => _connectedDevice;

  /// Check if currently connected
  bool get isConnected => _connectedDevice != null;

  /// Clean up resources
  void dispose() {
    _callback = null;
  }
}
