// Connectivity state provider - manages Bluetooth, CarPlay, network, and offline queue

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../core/logging/app_logger.dart';
import '../models/car.dart';
import '../services/api_service.dart';
import '../services/bluetooth_service.dart';
import '../services/carplay_service.dart';
import '../services/offline_queue.dart';
import 'car_provider.dart';

// Callback for unknown device - used to trigger car linking flow
typedef UnknownDeviceCallback = void Function(String deviceName);

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider(this._api, this._carProvider) {
    _offlineQueue = OfflineQueue(_api);
    _carPlay = CarPlayService();
    _bluetooth = BluetoothService();
  }

  static const _log = AppLogger('ConnectivityProvider');

  // Dependencies
  final ApiService _api;
  final CarProvider _carProvider;

  // Services
  late OfflineQueue _offlineQueue;
  late CarPlayService _carPlay;
  late BluetoothService _bluetooth;

  // State
  bool _isOnline = true;
  int _queueLength = 0;
  bool _isCarPlayConnected = false;
  bool _isBluetoothConnected = false;
  String? _connectedBluetoothDevice;
  String? _pendingUnknownDevice; // Device waiting to be linked to a car

  // Getters
  bool get isOnline => _isOnline;
  int get queueLength => _queueLength;
  bool get isCarPlayConnected => _isCarPlayConnected;
  bool get isBluetoothConnected => _isBluetoothConnected;
  String? get connectedBluetoothDevice => _connectedBluetoothDevice;
  String? get pendingUnknownDevice => _pendingUnknownDevice;

  // Callbacks for cross-provider communication
  UnknownDeviceCallback? onUnknownDevice;
  VoidCallback? onCarPlayConnected;
  void Function(String deviceName)? onBluetoothDeviceConnected;

  /// Initialize connectivity listeners - call after construction
  Future<void> init() async {
    _listenToConnectivity();
    _setupCarPlayListener();
    _setupBluetoothListener();
    unawaited(_checkConnectivity());
  }

  void _setupCarPlayListener() {
    // Check initial CarPlay status
    _carPlay.checkConnection().then((connected) {
      _isCarPlayConnected = connected;
      notifyListeners();
    });

    // Listen for CarPlay connection changes
    _carPlay.setConnectionCallback(({required connected}) {
      _isCarPlayConnected = connected;
      notifyListeners();

      if (connected) {
        _log.info('CarPlay connected - triggering callback...');
        onCarPlayConnected?.call();
      } else {
        // When CarPlay disconnects, keep tracking - backend will end trip
        _log.info('CarPlay disconnected - keeping trip active, backend will end when parked');
      }
    });
  }

  void _setupBluetoothListener() {
    // Check initial Bluetooth status
    _bluetooth.getConnectedDevice().then((deviceName) {
      _connectedBluetoothDevice = deviceName;
      _isBluetoothConnected = deviceName != null;
      if (deviceName != null) {
        onBluetoothDeviceConnected?.call(deviceName);
      }
      notifyListeners();
    });

    // Listen for Bluetooth connection changes
    _bluetooth.setConnectionCallback((deviceName) {
      _connectedBluetoothDevice = deviceName;
      _isBluetoothConnected = deviceName != null;
      notifyListeners();

      if (deviceName != null) {
        _log.info('Bluetooth connected: $deviceName - triggering callback...');
        onBluetoothDeviceConnected?.call(deviceName);
      } else {
        _log.info('Bluetooth disconnected');
      }
    });
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) {
      final wasOffline = !_isOnline;
      _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);

      if (wasOffline && _isOnline) {
        // Back online - process queue
        processQueue();
      }
      notifyListeners();
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    notifyListeners();
  }

  /// Get currently connected Bluetooth device name
  Future<String?> getConnectedDevice() => _bluetooth.getConnectedDevice();

  /// Check if a device matches a known car
  Car? findCarByDeviceId(String deviceName) => _carProvider.findCarByDeviceId(deviceName);

  /// Set pending unknown device and trigger callback
  void setPendingUnknownDevice(String deviceName) {
    _pendingUnknownDevice = deviceName;
    notifyListeners();
    onUnknownDevice?.call(deviceName);
  }

  /// Clear pending unknown device (after user links it or dismisses)
  void clearPendingUnknownDevice() {
    _pendingUnknownDevice = null;
    notifyListeners();
  }

  // ============ Offline Queue Management ============

  Future<void> refreshQueueLength() async {
    _queueLength = await _offlineQueue.getQueueLength();
    notifyListeners();
  }

  /// Process offline queue. Returns callback to notify when trip needs refresh.
  Future<({int success, int failed})> processQueue() async {
    final result = await _offlineQueue.processQueue();
    await refreshQueueLength();
    return result;
  }

  /// Add request to offline queue
  Future<void> addToQueue(String endpoint, double lat, double lng, {String? deviceId}) async {
    await _offlineQueue.addToQueue(endpoint, lat, lng, deviceId: deviceId);
    await refreshQueueLength();
  }

  /// Clear offline queue
  Future<void> clearQueue() async {
    await _offlineQueue.clearQueue();
    await refreshQueueLength();
  }

  @override
  void dispose() {
    _bluetooth.dispose();
    _carPlay.dispose();
    super.dispose();
  }
}
