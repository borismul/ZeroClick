// VW Group OAuth login screen (Volkswagen, Skoda, SEAT, CUPRA)

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// VW Group OAuth login screen - WebView for Volkswagen/Skoda/SEAT/CUPRA authentication
class VWGroupLoginScreen extends StatefulWidget {
  final String authUrl;
  final String redirectUri;
  final String brandName;
  final Color brandColor;

  const VWGroupLoginScreen({
    super.key,
    required this.authUrl,
    required this.redirectUri,
    required this.brandName,
    required this.brandColor,
  });

  @override
  State<VWGroupLoginScreen> createState() => _VWGroupLoginScreenState();
}

class _VWGroupLoginScreenState extends State<VWGroupLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false;

  // Redirect URI schemes for each brand
  static const _redirectSchemes = [
    'weconnect://',
    'myskoda://',
    'cupraconnect://',
    'seatconnect://',
  ];

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
            // Intercept redirect URIs
            for (final scheme in _redirectSchemes) {
              if (request.url.startsWith(scheme)) {
                _popWithResult(request.url);
                return NavigationDecision.prevent;
              }
            }
            // Also check for specific redirect URI
            if (widget.redirectUri.isNotEmpty &&
                request.url.startsWith(widget.redirectUri)) {
              _popWithResult(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            // Also check on page start
            for (final scheme in _redirectSchemes) {
              if (url.startsWith(scheme)) {
                _popWithResult(url);
                return;
              }
            }
            if (widget.redirectUri.isNotEmpty &&
                url.startsWith(widget.redirectUri)) {
              _popWithResult(url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // Custom schemes will cause errors - capture the URL
            final errorUrl = error.url;
            if (errorUrl != null) {
              for (final scheme in _redirectSchemes) {
                if (errorUrl.startsWith(scheme)) {
                  _popWithResult(errorUrl);
                  return;
                }
              }
              if (widget.redirectUri.isNotEmpty &&
                  errorUrl.startsWith(widget.redirectUri)) {
                _popWithResult(errorUrl);
              }
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
        title: Text('${widget.brandName} Login'),
        backgroundColor: widget.brandColor,
        foregroundColor: Colors.white,
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
