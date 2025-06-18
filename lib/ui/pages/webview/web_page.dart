import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../base/base_scaffold.dart';
import '../../../utils/toast_utils.dart';

class WebPage extends StatelessWidget {
  final String title;
  final String url;
  late final WebViewController controller;

  WebPage({required this.title, required this.url}) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            showLoading();
          },
          onPageFinished: (String url) {
            dismissLoading();
          },
          onWebResourceError: (WebResourceError error) {
            dismissLoading();
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(url);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: title,
      body: WebViewWidget(controller: controller),
    );
  }
}
