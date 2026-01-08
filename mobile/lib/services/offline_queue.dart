// Offline queue service - queues webhook calls when offline

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
import 'api_service.dart';

class OfflineQueue {
  static const String _queueKey = 'offline_queue';
  static const int _maxRetries = 5;

  final ApiService _api;
  bool _isProcessing = false;

  OfflineQueue(this._api);

  Future<void> addToQueue(String endpoint, double lat, double lng, {String? deviceId}) async {
    final queue = await getQueue();
    final request = QueuedRequest(
      id: '${DateTime.now().millisecondsSinceEpoch}-${_generateId()}',
      endpoint: endpoint,
      lat: lat,
      lng: lng,
      timestamp: DateTime.now(),
      deviceId: deviceId,
    );
    queue.add(request);
    await _saveQueue(queue);
  }

  Future<List<QueuedRequest>> getQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_queueKey);
      if (data == null) return [];
      final List<dynamic> list = jsonDecode(data) as List<dynamic>;
      return list
          .map((e) => QueuedRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveQueue(List<QueuedRequest> queue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _queueKey,
      jsonEncode(queue.map((e) => e.toJson()).toList()),
    );
  }

  Future<int> getQueueLength() async {
    final queue = await getQueue();
    return queue.length;
  }

  Future<({int success, int failed})> processQueue() async {
    if (_isProcessing) {
      return (success: 0, failed: 0);
    }

    _isProcessing = true;
    int success = 0;
    int failed = 0;

    try {
      final queue = await getQueue();
      if (queue.isEmpty) {
        return (success: 0, failed: 0);
      }

      final remaining = <QueuedRequest>[];

      for (final request in queue) {
        try {
          await _processRequest(request);
          success++;
        } catch (e) {
          request.retryCount++;
          if (request.retryCount < _maxRetries) {
            remaining.add(request);
          } else {
            failed++;
          }
        }
      }

      await _saveQueue(remaining);
    } finally {
      _isProcessing = false;
    }

    return (success: success, failed: failed);
  }

  Future<void> _processRequest(QueuedRequest request) async {
    switch (request.endpoint) {
      case 'start':
        await _api.startTrip(request.lat, request.lng, deviceId: request.deviceId);
        break;
      case 'end':
        await _api.endTrip(request.lat, request.lng);
        break;
      case 'ping':
        await _api.sendPing(request.lat, request.lng);
        break;
      default:
        throw Exception('Unknown endpoint: ${request.endpoint}');
    }
  }

  Future<void> clearQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
  }

  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(9, (i) => chars[(DateTime.now().microsecond + i) % chars.length]).join();
  }
}
