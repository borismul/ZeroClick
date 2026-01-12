import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/debug_log_service.dart';

class DebugLogScreen extends StatefulWidget {
  const DebugLogScreen({super.key});

  @override
  State<DebugLogScreen> createState() => _DebugLogScreenState();
}

class _DebugLogScreenState extends State<DebugLogScreen> {
  final _debugService = DebugLogService.instance;
  String? _filterTag;

  @override
  void initState() {
    super.initState();
    _debugService.addListener(_onLogsChanged);
  }

  @override
  void dispose() {
    _debugService.removeListener(_onLogsChanged);
    super.dispose();
  }

  void _onLogsChanged() {
    if (mounted) setState(() {});
  }

  List<DebugLogEntry> get _filteredLogs {
    if (_filterTag == null) return _debugService.logs;
    return _debugService.logs.where((l) => l.tag == _filterTag).toList();
  }

  Set<String> get _availableTags {
    return _debugService.logs.map((l) => l.tag).toSet();
  }

  Color _getTagColor(String tag) {
    if (tag.contains('LiveActivity')) return Colors.green;
    if (tag.contains('Motion')) return Colors.blue;
    if (tag.contains('Drive')) return Colors.orange;
    if (tag.contains('Watch')) return Colors.purple;
    if (tag.contains('API')) return Colors.cyan;
    if (tag.contains('Location')) return Colors.teal;
    if (tag.contains('Config')) return Colors.indigo;
    if (tag.contains('Debug')) return Colors.grey;
    return Colors.blueGrey;
  }

  Color _getMessageColor(DebugLogEntry entry) {
    final msg = entry.message.toLowerCase();
    if (msg.contains('error') || msg.contains('failed')) return Colors.red;
    if (msg.contains('success') || msg.contains('started')) return Colors.green;
    if (msg.contains('warning')) return Colors.orange;
    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    final logs = _filteredLogs;
    final tags = _availableTags.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy all logs',
            onPressed: () {
              final text = _debugService.exportLogs();
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logs copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear logs',
            onPressed: () {
              _debugService.clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          if (tags.isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: _filterTag == null,
                      onSelected: (_) => setState(() => _filterTag = null),
                    ),
                  ),
                  ...tags.map((tag) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: FilterChip(
                      label: Text(tag),
                      selected: _filterTag == tag,
                      selectedColor: _getTagColor(tag).withOpacity(0.3),
                      onSelected: (_) => setState(() => _filterTag = _filterTag == tag ? null : tag),
                    ),
                  )),
                ],
              ),
            ),

          // Log count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${logs.length} logs',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                const Spacer(),
                Text(
                  'Latest first',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Logs list
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text(
                      'No logs yet.\nStart driving to see Live Activity logs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return _LogEntryTile(
                        entry: log,
                        tagColor: _getTagColor(log.tag),
                        messageColor: _getMessageColor(log),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  final DebugLogEntry entry;
  final Color tagColor;
  final Color messageColor;

  const _LogEntryTile({
    required this.entry,
    required this.tagColor,
    required this.messageColor,
  });

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:'
        '${dt.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timestamp
          Text(
            _formatTime(entry.timestamp),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(width: 8),
          // Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              entry.tag,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: tagColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Message
          Expanded(
            child: Text(
              entry.message,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: messageColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
