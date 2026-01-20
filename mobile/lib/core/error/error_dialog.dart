import 'package:flutter/material.dart';
import 'error_handler.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    required this.errorInfo,
    super.key,
    this.onDismiss,
  });

  final ErrorInfo errorInfo;
  final VoidCallback? onDismiss;

  static Future<void> show(
    BuildContext context,
    ErrorInfo errorInfo, {
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(
        errorInfo: errorInfo,
        onDismiss: onDismiss ?? () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        _iconForSeverity(errorInfo.severity),
        color: _colorForSeverity(errorInfo.severity),
        size: 48,
      ),
      title: Text(errorInfo.title),
      content: Text(errorInfo.message),
      actions: [
        if (errorInfo.canRetry && errorInfo.onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              errorInfo.onRetry!();
            },
            child: const Text('Opnieuw proberen'),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss?.call();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  IconData _iconForSeverity(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return Icons.info_outline;
      case ErrorSeverity.warning:
        return Icons.warning_amber_outlined;
      case ErrorSeverity.error:
      case ErrorSeverity.fatal:
        return Icons.error_outline;
    }
  }

  Color _colorForSeverity(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return Colors.blue;
      case ErrorSeverity.warning:
        return Colors.orange;
      case ErrorSeverity.error:
      case ErrorSeverity.fatal:
        return Colors.red;
    }
  }
}
