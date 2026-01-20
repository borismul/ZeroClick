import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/error_provider.dart';
import 'error_dialog.dart';

class ErrorListener extends StatefulWidget {
  final Widget child;

  const ErrorListener({super.key, required this.child});

  @override
  State<ErrorListener> createState() => _ErrorListenerState();
}

class _ErrorListenerState extends State<ErrorListener> {
  bool _isShowingDialog = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ErrorProvider>(
      builder: (context, errorProvider, child) {
        // Show dialog when error changes
        if (errorProvider.currentError != null && !_isShowingDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorDialog(context, errorProvider);
          });
        }
        return widget.child;
      },
    );
  }

  Future<void> _showErrorDialog(
    BuildContext context,
    ErrorProvider errorProvider,
  ) async {
    if (_isShowingDialog) return;
    _isShowingDialog = true;

    await ErrorDialog.show(
      context,
      errorProvider.currentError!,
      onDismiss: () {
        errorProvider.clearError();
      },
    );

    _isShowingDialog = false;
  }
}
