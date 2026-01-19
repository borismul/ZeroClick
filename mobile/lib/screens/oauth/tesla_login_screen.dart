// Tesla OAuth login screen

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Tesla OAuth login screen - WebView for Tesla authentication
class TeslaLoginScreen extends StatefulWidget {
  final String authUrl;

  const TeslaLoginScreen({super.key, required this.authUrl});

  @override
  State<TeslaLoginScreen> createState() => _TeslaLoginScreenState();
}

class _TeslaLoginScreenState extends State<TeslaLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false;

  void _popWithResult(String? url) {
    if (!_hasPopped && mounted) {
      _hasPopped = true;
      Navigator.of(context).pop(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Check if this is the callback URL
            if (url.contains('auth.tesla.com/void/callback')) {
              _popWithResult(url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // Callback URL will show as error - that's fine
            if (error.url?.contains('void/callback') == true) {
              _popWithResult(error.url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tesla Login'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
