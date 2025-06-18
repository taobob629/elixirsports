import 'package:elixir_esports/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pgw_sdk/core/pgw_sdk_delegate.dart';
import 'package:pgw_sdk/core/pgw_webview_navigation_delegate.dart';
import 'package:pgw_sdk/enum/api_response_code.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../base/base_scaffold.dart';
import '../../../utils/toast_utils.dart';

class PGWWebViewPage extends StatelessWidget {
  late WebViewController controller;

  PGWWebViewPage({super.key}) {
    String url = Get.arguments["url"];
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(PGWNavigationDelegate(onNavigationRequest: (NavigationRequest request) {
        return NavigationDecision.navigate;
      }, onHttpAuthRequest: (HttpAuthRequest request) {
        flog("PaymentPage = onHttpAuthRequest");
      }, onProgress: (int progress) {
        flog("PaymentPage = onProgress:$progress");
      }, onPageStarted: (String url) {
        showLoading();
      }, onPageFinished: (String url) {
        dismissLoading();
      }, onWebResourceError: (WebResourceError error) {
        flog("PaymentPage = onWebResourceError(${error.description})");
      }, onUrlChange: (UrlChange change) {
        print('change: $change');
      }, onInquiry: (String paymentToken) {
        // Do transaction status inquiry
        // HomeScreen.backPreviousScreen();
        // InfoApi.transactionStatus(paymentToken);
        flog("PaymentPage = onInquiry");
        queryTransaction();
      }))
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) => BaseScaffold(
        title: 'Payment'.tr,
        body: WebViewWidget(controller: controller),
      );

  void queryTransaction() async {
    showLoading();
    //Step 2: Construct transaction status inquiry request.
    Map<String, dynamic> transactionStatusRequest = {'paymentToken': Get.arguments["paymentToken"], 'additionalInfo': true};

    //Step 3: Retrieve transaction status inquiry response.
    PGWSDK().transactionStatus(transactionStatusRequest, (response) {
      dismissLoading();
      if (response['responseCode'] == APIResponseCode.transactionNotFound || response['responseCode'] == APIResponseCode.transactionCompleted) {
        //Read transaction status inquiry response.
        showToast("Payment successful".tr);
        Get.back(result: true);
      } else {
        //Get error response and display error.
        showError("(${response['responseDescription']})");
        Get.back(result: false);
      }
    }, (error) {
      //Get error response and display error.
      showToast("($error)");
      Get.back(result: false);
    });
  }
}
