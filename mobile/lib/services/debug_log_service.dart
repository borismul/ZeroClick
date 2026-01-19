import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service to capture and display debug logs from native iOS code
class DebugLogService extends ChangeNotifier {
  DebugLogService._();
  static final DebugLogService instance = DebugLogService._();

  static const _channel = MethodChannel('com.zeroclick/debug');
  static const int _maxLogs = 500;

  final List<DebugLogEntry> _logs = [];
  List<DebugLogEntry> get logs => List.unmodifiable(_logs);

  bool _isInitialized = false;

  void init() {
    if (_isInitialized) return;
    _isInitialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'log') {
        final args = call.arguments as Map<dynamic, dynamic>;
        final tag = args['tag'] as String? ?? 'Native';
        final message = args['message'] as String? ?? '';
        addLog(tag, message);
      }
      return null;
    });

    addLog('Debug', 'Debug logging initialized');
  }

  void addLog(String tag, String message) {
    final entry = DebugLogEntry(
      timestamp: DateTime.now(),
      tag: tag,
      message: message,
    );
    _logs.insert(0, entry);

    // Keep only last N logs
    if (_logs.length > _maxLogs) {
      _logs.removeRange(_maxLogs, _logs.length);
    }

    notifyListeners();
  }

  void clear() {
    _logs.clear();
    addLog('Debug', 'Logs cleared');
  }

  String exportLogs() {
    final buffer = StringBuffer();
    for (final log in _logs.reversed) {
      buffer.writeln('[${_formatTime(log.timestamp)}] [${log.tag}] ${log.message}');
    }
    return buffer.toString();
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:'
        '${dt.second.toString().padLeft(2, '0')}.'
        '${dt.millisecond.toString().padLeft(3, '0')}';
  }
}

class DebugLogEntry {
  final DateTime timestamp;
  final String tag;
  final String message;

  DebugLogEntry({
    required this.timestamp,
    required this.tag,
    required this.message,
  });
}
