// Renault OAuth login screen (Gigya-based)

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Renault OAuth login screen - WebView for MY Renault authentication
class RenaultLoginScreen extends StatefulWidget {
  final String authUrl;
  final String gigyaApiKey;

  const RenaultLoginScreen({
    super.key,
    required this.authUrl,
    required this.gigyaApiKey,
  });

  @override
  State<RenaultLoginScreen> createState() => _RenaultLoginScreenState();
}

class _RenaultLoginScreenState extends State<RenaultLoginScreen> {
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
          onNavigationRequest: (NavigationRequest request) {
            // Intercept Renault app redirects
            if (request.url.startsWith('renault://') ||
                request.url.startsWith('myrenault://') ||
                request.url.contains('accounts.renault.com/callback')) {
              // Extract token from URL if present
              final uri = Uri.parse(request.url);
              final token = uri.queryParameters['id_token'] ??
                  uri.queryParameters['access_token'] ??
                  uri.fragment;
              if (token.isNotEmpty) {
                _popWithResult(token);
              } else {
                _popWithResult(request.url);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            // Check for redirects
            if (url.startsWith('renault://') ||
                url.startsWith('myrenault://')) {
              final uri = Uri.parse(url);
              final token = uri.queryParameters['id_token'] ??
                  uri.queryParameters['access_token'];
              _popWithResult(token ?? url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // Custom schemes will cause errors
            final errorUrl = error.url;
            if (errorUrl != null &&
                (errorUrl.startsWith('renault://') ||
                    errorUrl.startsWith('myrenault://'))) {
              _popWithResult(errorUrl);
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
        title: const Text('MY Renault Login'),
        backgroundColor: const Color(0xFFFFCC33),
        foregroundColor: Colors.black,
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
