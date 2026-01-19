// Audi OAuth login screen

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Audi OAuth login screen - WebView for myAudi authentication
class AudiLoginScreen extends StatefulWidget {
  final String authUrl;

  const AudiLoginScreen({super.key, required this.authUrl});

  @override
  State<AudiLoginScreen> createState() => _AudiLoginScreenState();
}

class _AudiLoginScreenState extends State<AudiLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false; // Prevent multiple pops

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
          onNavigationRequest: (NavigationRequest request) {
            // Intercept myaudi:// redirects
            if (request.url.startsWith('myaudi://')) {
              _popWithResult(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            // Also check on page start (some redirects don't trigger onNavigationRequest)
            if (url.startsWith('myaudi://')) {
              _popWithResult(url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // myaudi:// scheme will cause an error - capture the URL
            if (error.url?.startsWith('myaudi://') == true) {
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
        title: const Text('Audi Login'),
        backgroundColor: const Color(0xFFBB0A30),
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
