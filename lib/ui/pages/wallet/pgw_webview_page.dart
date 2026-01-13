import 'dart:async';
import 'package:elixir_esports/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pgw_sdk/core/pgw_sdk_delegate.dart';
import 'package:pgw_sdk/core/pgw_webview_navigation_delegate.dart';
import 'package:pgw_sdk/enum/api_response_code.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../api/wallet_api.dart';
import '../../../base/base_scaffold.dart';
import '../../../config/icon_font.dart';
import '../../../ui/widget/my_button_widget.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/toast_utils.dart';

class PGWWebViewPage extends StatefulWidget {
  const PGWWebViewPage({super.key});

  @override
  State<PGWWebViewPage> createState() => _PGWWebViewPageState();
}

class _PGWWebViewPageState extends State<PGWWebViewPage>
    with WidgetsBindingObserver {
  late WebViewController controller;
  late String redirectTarget;
  Timer? _sdkPollingTimer;
  int _sdkPollingAttempts = 0;
  bool _isSdkPollingActive = false;
  bool _isPaymentInitiated = false; // 标记用户是否真正发起了支付请求

  @override
  void initState() {
    super.initState();
    // 添加生命周期监听
    WidgetsBinding.instance.addObserver(this);

    // 初始化WebView和参数
    initWebView();
  }

  @override
  void dispose() {
    // 移除生命周期监听
    WidgetsBinding.instance.removeObserver(this);
    // 停止SDK轮询
    _stopSdkPolling();
    super.dispose();
  }

  void initWebView() {
    // 安全获取arguments
    final arguments = Get.arguments ?? {};
    String url = arguments["url"] ?? "";
    // 获取跳转目标，默认跳转到订单列表
    redirectTarget = arguments["redirectTarget"] ?? "orderList";

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          "Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.152 Mobile Safari/537.36")
      ..setNavigationDelegate(PGWNavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
        try {
          final Uri uri = Uri.parse(request.url);
          print("Navigation request: ${request.url}");
          print("Scheme: ${uri.scheme}");

          // 处理APP链接（如alipays://, weixin://等）
          if (uri.scheme != 'http' && uri.scheme != 'https') {
            // 标记用户真正发起了支付请求
            _isPaymentInitiated = true;
            print("Payment initiated: External app URL detected");

            // 尝试打开外部APP，添加完整的错误处理
            print("Opening external app: ${request.url}");

            // 特殊处理Alipay URLs - 绕过canLaunchUrl检查
            bool shouldBypassCheck = false;
            if (uri.scheme == 'alipays' ||
                request.url.toLowerCase().contains('alipay')) {
              shouldBypassCheck = true;
              print("Bypassing canLaunchUrl check for Alipay URL");
            }

            // 检查是否可以处理该URL，对Alipay URLs跳过检查
            final canLaunch =
                shouldBypassCheck || await canLaunchUrl(Uri.parse(request.url));
            if (canLaunch) {
              await launchUrl(Uri.parse(request.url),
                  mode: LaunchMode.externalApplication,
                  webViewConfiguration:
                      const WebViewConfiguration(enableJavaScript: true));
            } else {
              print("Cannot launch URL: ${request.url}");
              // 显示错误提示，不崩溃
              showToast(
                  "Cannot open the payment app. Please make sure the app is installed."
                      .tr);
            }
            return NavigationDecision.prevent;
          }

          // 处理https Alipay URLs with app_pay=Y parameter - 这些应该启动支付宝APP
          if (uri.scheme == 'https' &&
              request.url.toLowerCase().contains('alipay') &&
              request.url.toLowerCase().contains('app_pay=y')) {
            // 标记用户真正发起了支付请求
            _isPaymentInitiated = true;
            print("Payment initiated: Alipay app_pay URL detected");

            print("Alipay app_pay URL detected: ${request.url}");
            // 尝试打开外部APP，添加完整的错误处理
            try {
              // 特殊处理Alipay URLs - 绕过canLaunchUrl检查
              print("Bypassing canLaunchUrl check for Alipay app_pay URL");

              await launchUrl(Uri.parse(request.url),
                  mode: LaunchMode.externalApplication,
                  webViewConfiguration:
                      const WebViewConfiguration(enableJavaScript: true));
            } catch (e) {
              print("Error launching Alipay app: $e");
              // 显示错误提示，不崩溃
              showToast(
                  "Cannot open Alipay. Please make sure the app is installed."
                      .tr);
            }
            return NavigationDecision.prevent;
          }

          // 处理微信支付URLs - 标记支付已发起
          if (request.url.toLowerCase().contains('weixin') ||
              request.url.toLowerCase().contains('wechat')) {
            // 检查是否是微信支付发起URL
            if (request.url.toLowerCase().contains('wx.tenpay.com') ||
                request.url.toLowerCase().contains('weixin.qq.com') ||
                request.url.toLowerCase().contains('wechatpay.com')) {
              _isPaymentInitiated = true;
              print("Payment initiated: WeChat payment URL detected");
            }
          }

          // 特别处理支付宝相关域名
          if (request.url.contains('alipay') ||
              request.url.contains('mclient.alipay.com')) {
            print("Alipay domain detected: ${request.url}");
            // 允许导航，让支付宝页面正常加载
            return NavigationDecision.navigate;
          }

          return NavigationDecision.navigate;
        } catch (e) {
          print("Error in navigation request: $e");
          // 捕获所有异常，防止崩溃
          showToast(
              "Error handling payment request. Please try again or use another payment method."
                  .tr);
          return NavigationDecision.prevent;
        }
      }, onHttpAuthRequest: (HttpAuthRequest request) {
        flog("PaymentPage = onHttpAuthRequest");
      }, onProgress: (int progress) {
        flog("PaymentPage = onProgress:$progress");
      }, onPageStarted: (String url) {
        showLoading();
      }, onPageFinished: (String url) {
        dismissLoading();
        // 页面加载完成后，检查页面内容中的关键字
        // showToast("----------onPageFinished---------------_checkPageContentForKeywords");
        _checkPageContentForKeywords();
      }, onWebResourceError: (WebResourceError error) {
        flog("PaymentPage = onWebResourceError(${error.description})");
      }, onUrlChange: (UrlChange change) {
        print('change: $change');
      }, onInquiry: (String paymentToken) {
        // Do transaction status inquiry
        flog("PaymentPage = onInquiry");
        queryTransaction(paymentToken);
      }))
      // 注入JavaScript通道，用于获取页面内容
      ..addJavaScriptChannel(
        'PaymentStatusChecker',
        onMessageReceived: (JavaScriptMessage message) {
          _checkPaymentKeywords(message.message);
        },
      )
      // 注入JavaScript通道，用于检测支付按钮点击
      ..addJavaScriptChannel(
        'PaymentInitiationDetector',
        onMessageReceived: (JavaScriptMessage message) {
          // 收到支付按钮点击通知
          _isPaymentInitiated = true;
          print("Payment initiated: Button clicked - ${message.message}");
        },
      )
      ..loadRequest(Uri.parse(url));
  }

  // 执行JavaScript获取页面内容，检查是否包含支付成功关键字，并注入支付按钮点击检测
  void _checkPageContentForKeywords() {
    try {
      // 执行JavaScript获取页面的文本内容和标题，并注入支付按钮点击检测
      String jsCode = '''
        // 检测支付按钮点击的综合方案
        (function() {
          // 1. 获取页面内容（用于支付状态检测）
          function getPageContent() {
            const pageText = document.body.innerText.toLowerCase();
            const pageTitle = document.title.toLowerCase();
            const combinedText = pageText + ' ' + pageTitle;
            return combinedText;
          }
          PaymentStatusChecker.postMessage(getPageContent());
          
          // 2. 检测所有按钮点击，特别是包含支付相关文本的按钮
          function detectPaymentButtons() {
            const allButtons = document.querySelectorAll('button, input[type="button"], input[type="submit"], a');
            
            // 定义支付相关关键词
            const paymentKeywords = [
              'pay', 'payment', 'buy', 'purchase', 'checkout', 'confirm',
              'pay now', 'confirm payment', 'submit', '完成', '支付', '确认',
              '立即支付', '确认支付', '提交订单', '下单', '付款'
            ];
            
            allButtons.forEach(button => {
              // 检查按钮文本或aria标签是否包含支付关键词
              const buttonText = (button.textContent || button.innerText || button.value || button.getAttribute('aria-label') || '').toLowerCase();
              const hasPaymentKeyword = paymentKeywords.some(keyword => buttonText.includes(keyword.toLowerCase()));
              
              // 检查按钮是否有支付相关的类名或ID
              const hasPaymentClass = button.className && button.className.toLowerCase().match(/pay|payment|checkout|confirm|submit/);
              const hasPaymentId = button.id && button.id.toLowerCase().match(/pay|payment|checkout|confirm|submit/);
              
              // 检查按钮是否指向支付相关URL
              const hasPaymentHref = button.tagName === 'A' && button.href && 
                (button.href.toLowerCase().includes('pay') || 
                 button.href.toLowerCase().includes('payment') ||
                 button.href.toLowerCase().includes('checkout'));
              
              // 如果是支付按钮，添加点击监听
              if (hasPaymentKeyword || hasPaymentClass || hasPaymentId || hasPaymentHref) {
                button.addEventListener('click', function() {
                  PaymentInitiationDetector.postMessage('Payment button clicked: ' + buttonText);
                });
              }
            });
          }
          
          // 3. 监听所有表单提交事件，特别是支付表单
          function detectFormSubmissions() {
            document.addEventListener('submit', function(e) {
              const form = e.target;
              // 检查表单是否有支付相关的属性
              const action = form.action.toLowerCase();
              const hasPaymentAction = action.includes('pay') || 
                                      action.includes('payment') ||
                                      action.includes('checkout') ||
                                      action.includes('confirm');
              
              // 检查表单内是否有支付相关按钮
              const formButtons = form.querySelectorAll('button, input[type="submit"]');
              let hasPaymentButton = false;
              for (let i = 0; i < formButtons.length; i++) {
                const buttonText = (formButtons[i].textContent || formButtons[i].innerText || formButtons[i].value || '').toLowerCase();
                if (buttonText.includes('pay') || buttonText.includes('支付') || buttonText.includes('confirm')) {
                  hasPaymentButton = true;
                  break;
                }
              }
              
              if (hasPaymentAction || hasPaymentButton) {
                PaymentInitiationDetector.postMessage('Payment form submitted: ' + action);
              }
            });
          }
          
          // 4. 监听页面中的支付相关API调用
          function detectPaymentApiCalls() {
            // 保存原始的fetch和XMLHttpRequest
            const originalFetch = window.fetch;
            const originalXHROpen = window.XMLHttpRequest.prototype.open;
            
            // 重写fetch方法
            window.fetch = function(url, options) {
              // 检查URL是否包含支付相关关键词
              if (typeof url === 'string' && 
                  (url.toLowerCase().includes('pay') || 
                   url.toLowerCase().includes('payment') ||
                   url.toLowerCase().includes('transaction'))) {
                PaymentInitiationDetector.postMessage('Payment API call: ' + url);
              }
              return originalFetch.apply(this, arguments);
            };
            
            // 重写XMLHttpRequest.open方法
            window.XMLHttpRequest.prototype.open = function(method, url) {
              if (typeof url === 'string' && 
                  (url.toLowerCase().includes('pay') || 
                   url.toLowerCase().includes('payment') ||
                   url.toLowerCase().includes('transaction'))) {
                PaymentInitiationDetector.postMessage('Payment XHR call: ' + url);
              }
              return originalXHROpen.apply(this, arguments);
            };
          }
          
          // 5. 监听页面中的支付状态变化
          function detectPaymentStatusChanges() {
            // 监听URL变化，可能表示支付流程进展
            let lastUrl = window.location.href;
            setInterval(function() {
              if (window.location.href !== lastUrl) {
                lastUrl = window.location.href;
                // 检查新URL是否包含支付相关状态
                if (lastUrl.toLowerCase().includes('success') || 
                    lastUrl.toLowerCase().includes('failed') ||
                    lastUrl.toLowerCase().includes('status')) {
                  PaymentInitiationDetector.postMessage('Payment status URL changed: ' + lastUrl);
                }
              }
            }, 500);
          }
          
          // 执行所有检测函数
          detectPaymentButtons();
          detectFormSubmissions();
          detectPaymentApiCalls();
          detectPaymentStatusChanges();
          
          // 监听DOM变化，动态检测新添加的支付按钮
          const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
              if (mutation.type === 'childList') {
                detectPaymentButtons();
              }
            });
          });
          
          // 配置并启动观察器
          observer.observe(document.body, {
            childList: true,
            subtree: true
          });
        })();
      ''';
      controller.runJavaScript(jsCode);
    } catch (e) {
      print("Error checking page content and injecting payment detection: $e");
    }
  }

  // 检查页面内容中是否包含支付成功关键字
  void _checkPaymentKeywords(String pageContent) {
    print("Checking page content for payment keywords: $pageContent");
    // showToast("Checking page content for payment keywords: $pageContent");

    // 定义支付成功的关键字列表
    const successKeywords = [
      'success',
      'successful',
      'transaction is successful',
      'transaction is successful.',
      'payment successful',
      'payment completed',
      'transaction successful',
      'transaction completed',
      'payment success',
      '订单成功',
      '支付成功',
      '交易成功',
      '完成支付',
      'payment has been made',
      'payment accepted'
    ];

    // 检查是否包含任何成功关键字
    for (final keyword in successKeywords) {
      if (pageContent.contains(keyword.toLowerCase())) {
        print("Found success keyword: $keyword");
        // 支付成功，取消轮询并返回成功结果
        // if (_pollingTimer != null && _pollingTimer!.isActive) {
        //   _pollingTimer!.cancel();
        //   _pollingTimer = null;
        // }
        showToast("Payment successful".tr);
        Get.back(result: true);
        return;
      }
    }

    // 检查是否包含失败关键字
    const failureKeywords = [
      'failed',
      'failure',
      'payment failed',
      'transaction failed',
      'payment error',
      'transaction error',
      'cancelled',
      'canceled',
      'payment cancelled',
      'transaction cancelled',
      '订单失败',
      '支付失败',
      '交易失败',
      '取消支付',
      'payment rejected'
    ];

    // 检查是否包含任何失败关键字
    for (final keyword in failureKeywords) {
      if (pageContent.contains(keyword.toLowerCase())) {
        print("Found failure keyword: $keyword");
        // 支付失败，取消轮询并返回失败结果
        // if (_pollingTimer != null && _pollingTimer!.isActive) {
        //   _pollingTimer!.cancel();
        //   _pollingTimer = null;
        // }
        showInfo("Payment failed".tr);
        Get.back(result: false);
        return;
      }
    }

    print("No payment status keywords found in page content");
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          // 当用户点击返回按钮或从webview回退时，检查是否可以返回webview上一页
          if (await controller.canGoBack()) {
            // 如果可以返回webview上一页，继续返回
            await controller.goBack();
            return false;
          } else {
            // 如果已经是webview第一页，用户从webview回退到支付页面
            print("User is exiting webview, returning to payment page");
            // 停止SDK轮询
            _stopSdkPolling();
            // 获取orderId
            String orderId = "";
            try {
              final arguments = Get.arguments ?? {};
              orderId = arguments["orderId"] ?? "";
            } catch (e) {
              print("Error getting orderId: $e");
              orderId = "";
            }

            // 只有当用户真正发起了支付请求时，才返回orderId进行轮询
            // 否则返回null，不需要轮询订单状态
            print("Payment initiated: $_isPaymentInitiated");
            Get.back(
                result:
                    _isPaymentInitiated && orderId.isNotEmpty ? orderId : null);
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: toColor('F5F5F5'),
          appBar: AppBar(
            backgroundColor: Colors.white,
            // 自定义返回按钮
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: toColor("3d3d3d"),
              ),
              onPressed: () async {
                // 执行正常返回逻辑
                if (await controller.canGoBack()) {
                  // 如果可以返回webview上一页，继续返回
                  await controller.goBack();
                } else {
                  // 如果已经是webview第一页，用户从webview回退到支付页面
                  print(
                      "User is exiting webview via app bar button, returning to payment page");
                  // 停止SDK轮询
                  _stopSdkPolling();
                  // 获取orderId
                  String orderId = "";
                  try {
                    final arguments = Get.arguments ?? {};
                    orderId = arguments["orderId"] ?? "";
                  } catch (e) {
                    print("Error getting orderId: $e");
                    orderId = "";
                  }

                  // 只有当用户真正发起了支付请求时，才返回orderId进行轮询
                  // 否则返回null，不需要轮询订单状态
                  print("Payment initiated: $_isPaymentInitiated");
                  Get.back(
                      result: _isPaymentInitiated && orderId.isNotEmpty
                          ? orderId
                          : null);
                }
              },
            ),
            elevation: 0,
            title: Text(
              'Payment'.tr,
              style: TextStyle(
                color: toColor("3d3d3d"),
                fontFamily: FONT_MEDIUM,
                fontSize: 16.sp,
              ),
            ),
          ),
          body: Stack(
            children: [
              WebViewWidget(controller: controller),
            ],
          ),
        ),
      );

  void queryTransaction(String paymentToken) async {
    showLoading();
    // 安全获取orderId，防止Get.arguments为null
    String orderId = "";
    try {
      orderId = Get.arguments?["orderId"] ?? "";
    } catch (e) {
      print("Error getting orderId: $e");
      orderId = "";
    }

    print("-----------------------queryTransaction orderId:$orderId");
    // 开始SDK轮询
    _startSdkPolling(paymentToken);
  }

  /// 开始SDK轮询，最多200次，间隔2秒
  void _startSdkPolling(String paymentToken) {
    // 停止现有轮询
    _stopSdkPolling();

    _isSdkPollingActive = true;
    _sdkPollingAttempts = 0;

    //Step 2: Construct transaction status inquiry request.
    Map<String, dynamic> transactionStatusRequest = {
      'paymentToken': paymentToken,
      'additionalInfo': true
    };

    // 立即执行第一次轮询
    _performSdkPolling(paymentToken, transactionStatusRequest);

    // 设置定时器，每2秒执行一次轮询
    _sdkPollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _performSdkPolling(paymentToken, transactionStatusRequest);
    });
  }

  /// 执行单次SDK轮询
  void _performSdkPolling(String paymentToken, Map<String, dynamic> request) {
    _sdkPollingAttempts++;
    print(
        "SDK Polling - Attempt $_sdkPollingAttempts/200 for paymentToken: $paymentToken");

    //Step 3: Retrieve transaction status inquiry response.
    PGWSDK().transactionStatus(request, (response) {
      if (response['responseCode'] == APIResponseCode.transactionCompleted) {
        // Payment successful
        _stopSdkPolling();
        dismissLoading();
        showToast("Payment successful".tr);
        // 根据redirectTarget决定跳转目标
        if (redirectTarget == "wallet") {
          // 充值成功，跳转到钱包页面
          Get.offAllNamed("/wallet");
        } else {
          // 商品支付成功，默认跳转到订单列表
          Get.back(result: true);
        }
      } else if (response['responseCode'] ==
          APIResponseCode.transactionNotFound) {
        // Payment failed
        _stopSdkPolling();
        dismissLoading();
        showInfo("Payment failed".tr);
        Get.back(result: false);
      } else if (_sdkPollingAttempts >= 200) {
        // 轮询达到最大次数，停止轮询
        _stopSdkPolling();
        dismissLoading();
        print("SDK Polling timed out after 200 attempts");
      }
      // 其他状态，继续轮询
    }, (error) {
      // API call failed
      if (_sdkPollingAttempts >= 200) {
        // 轮询达到最大次数，停止轮询
        _stopSdkPolling();
        dismissLoading();
        print("SDK Polling timed out after 200 attempts due to API error");
      }
    });
  }

  /// 停止SDK轮询
  void _stopSdkPolling() {
    if (_sdkPollingTimer != null && _sdkPollingTimer!.isActive) {
      _sdkPollingTimer!.cancel();
      _sdkPollingTimer = null;
    }
    _isSdkPollingActive = false;
    _sdkPollingAttempts = 0;
    print("SDK Polling stopped");
  }
}
