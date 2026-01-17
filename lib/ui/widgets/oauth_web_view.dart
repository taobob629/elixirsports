import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// OAuth WebView widget for handling OAuth 2.0 authentication flows
class OAuthWebView extends StatefulWidget {
  /// The initial URL to load for OAuth authentication
  final String url;
  
  /// The callback URL scheme to listen for
  final String callbackUrlScheme;
  
  /// Called when the OAuth flow completes successfully
  final void Function(String callbackUrl) onSuccess;
  
  /// Called when the OAuth flow is canceled
  final void Function() onCancel;

  const OAuthWebView({
    super.key,
    required this.url,
    required this.callbackUrlScheme,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<OAuthWebView> createState() => _OAuthWebViewState();
}

class _OAuthWebViewState extends State<OAuthWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.parse(request.url);
            
            // Check if this is our callback URL
            if (uri.scheme == widget.callbackUrlScheme) {
              // Handle the callback URL
              widget.onSuccess(request.url);
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            
            // Allow all other navigation requests
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onCancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}