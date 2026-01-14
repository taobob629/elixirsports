import 'dart:async';
import 'package:elixir_esports/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import '../../../utils/logger_service.dart';

class PGWWebViewPage extends StatefulWidget {
  const PGWWebViewPage({super.key});

  @override
  State<PGWWebViewPage> createState() => _PGWWebViewPageState();
}

class _PGWWebViewPageState extends State<PGWWebViewPage>
    with WidgetsBindingObserver {
  late WebViewController controller;
  late String redirectTarget;

  bool _isSdkPollingActive = false;
  int _sdkPollingAttempts = 0;
  Timer? _sdkPollingTimer;

  // 标记用户是否真正发起了支付请求
  bool _isPaymentInitiated = false;
  // 标记用户是否点击了取消按钮
  bool _isPaymentCancelled = false;

  // 添加一个辅助方法来格式化带时间戳的打印
  void _printWithTime(String message) {
    final now = DateTime.now();
    final timeString = DateFormat('HH:mm:ss.SSS').format(now);
    print("$timeString $message");
  }

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
    String? orderId = arguments["orderId"];
    String? paymentToken = arguments["paymentToken"];
    // 获取跳转目标，默认跳转到订单列表
    redirectTarget = arguments["redirectTarget"] ?? "orderList";

    // 记录WebView初始化日志
    logger.payment('WebViewInit', 'Initializing PGW WebView', orderId: orderId);
    logger.payment('WebViewParams',
        'URL: $url, OrderId: $orderId, PaymentToken: $paymentToken, RedirectTarget: $redirectTarget');

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          "Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.152 Mobile Safari/537.36")
      ..setNavigationDelegate(PGWNavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
        try {
          final Uri uri = Uri.parse(request.url);
          logger.payment('WebViewNavRequest',
              'Navigation request: ${request.url}, Scheme: ${uri.scheme}',
              orderId: orderId);

          // 处理APP链接（如alipays://, weixin://等）
          if (uri.scheme != 'http' && uri.scheme != 'https') {
            // 标记用户真正发起了支付请求
            if (!_isPaymentInitiated) {
              _isPaymentInitiated = true;
              print('=== 第一次设置 _isPaymentInitiated 为 true ===');
              print('触发位置: 外部APP URL检测');
              print('URL: ${request.url}');
              print('时间: ${DateTime.now()}');
            }
            logger.payment(
                'PaymentInitiated', 'External app URL detected: ${request.url}',
                orderId: orderId);

            // 尝试打开外部APP，添加完整的错误处理
            logger.payment(
                'ExternalAppLaunch', 'Opening external app: ${request.url}',
                orderId: orderId);

            // 特殊处理Alipay URLs - 绕过canLaunchUrl检查
            bool shouldBypassCheck = false;
            if (uri.scheme == 'alipays' ||
                request.url.toLowerCase().contains('alipay')) {
              shouldBypassCheck = true;
              logger.payment('AlipaySpecialHandling',
                  'Bypassing canLaunchUrl check for Alipay URL',
                  orderId: orderId);
            }

            // 检查是否可以处理该URL，对Alipay URLs跳过检查
            final canLaunch =
                shouldBypassCheck || await canLaunchUrl(Uri.parse(request.url));
            if (canLaunch) {
              logger.payment('ExternalAppLaunchSuccess',
                  'Successfully launched external app',
                  orderId: orderId);
              await launchUrl(Uri.parse(request.url),
                  mode: LaunchMode.externalApplication,
                  webViewConfiguration:
                      const WebViewConfiguration(enableJavaScript: true));
            } else {
              logger.payment('ExternalAppLaunchFailed',
                  'Cannot launch URL: ${request.url}',
                  orderId: orderId);
              // 显示错误提示，不崩溃
              showToast(
                  "Cannot open the payment app. Please make sure the app is installed."
                      .tr);
            }
            return NavigationDecision.prevent;
          }

          // 处理支付宝URL
          if (request.url.toLowerCase().contains('alipay')) {
            // 标记用户真正发起了支付请求
            if (!_isPaymentInitiated) {
              _isPaymentInitiated = true;
              _printWithTime('=== 第一次设置 _isPaymentInitiated 为 true ===');
              _printWithTime('触发位置: 支付宝URL检测');
              _printWithTime('URL: ${request.url}');
            }
            logger.payment(
                'PaymentInitiated', 'Alipay URL detected: ${request.url}',
                orderId: orderId);

            // 处理带有app_pay=Y参数的支付宝URL，启动外部APP
            if (request.url.toLowerCase().contains('app_pay=y')) {
              logger.payment('AlipayAppLaunch',
                  'Alipay app_pay URL detected: ${request.url}',
                  orderId: orderId);
              // 尝试打开外部APP，添加完整的错误处理
              try {
                // 特殊处理Alipay URLs - 绕过canLaunchUrl检查
                logger.payment('AlipaySpecialHandling',
                    'Bypassing canLaunchUrl check for Alipay app_pay URL',
                    orderId: orderId);

                await launchUrl(Uri.parse(request.url),
                    mode: LaunchMode.externalApplication,
                    webViewConfiguration:
                        const WebViewConfiguration(enableJavaScript: true));
              } catch (e) {
                logger.e('AlipayLaunchError', 'Error launching Alipay app: $e',
                    error: e, orderId: orderId);
                // 显示错误提示，不崩溃
                showToast(
                    "Cannot open Alipay. Please make sure the app is installed."
                        .tr);
              }
              return NavigationDecision.prevent;
            }

            // 处理支付宝H5支付URL（如mclient.alipay.com/h5pay）
            if (request.url.contains('mclient.alipay.com') ||
                request.url.toLowerCase().contains('h5pay')) {
              logger.payment('AlipayH5Pay',
                  'Alipay H5 payment URL detected: ${request.url}',
                  orderId: orderId);
              // 允许在WebView中加载支付宝H5支付页面
              return NavigationDecision.navigate;
            }

            // 处理其他支付宝相关域名，允许在WebView中正常加载
            logger.payment(
                'AlipayDomain', 'Alipay domain detected: ${request.url}',
                orderId: orderId);
            return NavigationDecision.navigate;
          }

          // 处理微信支付URLs - 标记支付已发起
          if (request.url.toLowerCase().contains('weixin') ||
              request.url.toLowerCase().contains('wechat')) {
            // 检查是否是微信支付发起URL
            if (request.url.toLowerCase().contains('wx.tenpay.com') ||
                request.url.toLowerCase().contains('weixin.qq.com') ||
                request.url.toLowerCase().contains('wechatpay.com')) {
              if (!_isPaymentInitiated) {
                _isPaymentInitiated = true;
                _printWithTime('=== 第一次设置 _isPaymentInitiated 为 true ===');
                _printWithTime('触发位置: 微信支付URL检测');
                _printWithTime('URL: ${request.url}');
              }
              logger.payment('PaymentInitiated',
                  'WeChat payment URL detected: ${request.url}',
                  orderId: orderId);
            }
          }

          return NavigationDecision.navigate;
        } catch (e, stackTrace) {
          logger.e('NavigationError', 'Error in navigation request: $e',
              error: e, stackTrace: stackTrace, orderId: orderId);
          // 捕获所有异常，防止崩溃
          showToast(
              "Error handling payment request. Please try again or use another payment method."
                  .tr);
          return NavigationDecision.prevent;
        }
      }, onHttpAuthRequest: (HttpAuthRequest request) {
        logger.payment('HttpAuthRequest', 'onHttpAuthRequest',
            orderId: orderId);
      }, onProgress: (int progress) {
        logger.payment('WebViewProgress', 'onProgress: $progress',
            orderId: orderId);
      }, onPageStarted: (String url) {
        logger.payment('PageStarted', 'onPageStarted: $url', orderId: orderId);
        showLoading();
      }, onPageFinished: (String url) {
        logger.payment('PageFinished', 'onPageFinished: $url',
            orderId: orderId);
        dismissLoading();
        // 页面加载完成后，检查页面内容中的关键字
        // showToast("----------onPageFinished---------------_checkPageContentForKeywords");
        _checkPageContentForKeywords();
      }, onWebResourceError: (WebResourceError error) {
        logger.e('WebResourceError', 'onWebResourceError: ${error.description}',
            error: error, orderId: orderId);
      }, onUrlChange: (UrlChange change) {
        logger.payment('UrlChange', 'URL changed: $change', orderId: orderId);
      }, onInquiry: (String paymentToken) {
        // Do transaction status inquiry
        logger.payment('SdkInquiry', 'onInquiry: $paymentToken',
            orderId: orderId);
        queryTransaction(paymentToken);
      }))
      // 注入JavaScript通道，用于获取页面内容
      ..addJavaScriptChannel(
        'PaymentStatusChecker',
        onMessageReceived: (JavaScriptMessage message) {
          _checkPaymentKeywords(message.message);
        },
      )
      // 注入JavaScript通道，用于检测支付按钮点击和取消按钮点击
      ..addJavaScriptChannel(
        'PaymentInitiationDetector',
        onMessageReceived: (JavaScriptMessage message) {
          String msg = message.message.toLowerCase();
          _printWithTime('Received button click: $msg');

          // 检测是否是取消按钮点击
          if (msg.contains('cancel') ||
              msg.contains('back') ||
              msg.contains('返回') ||
              msg.contains('取消')) {
            _isPaymentCancelled = true;
            _printWithTime('=== 检测到取消按钮点击，设置 _isPaymentCancelled 为 true ===');
            logger.payment('PaymentCancelled',
                'Cancel button clicked - ${message.message}',
                orderId: orderId);
          } else if (!_isPaymentInitiated) {
            // 收到支付按钮点击通知
            _isPaymentInitiated = true;
            _printWithTime('=== 第一次设置 _isPaymentInitiated 为 true ===');
            _printWithTime('触发位置: 支付按钮点击检测');
            _printWithTime('消息: ${message.message}');
            logger.payment('PaymentInitiated',
                'Payment button clicked - ${message.message}',
                orderId: orderId);
          }
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
            // 尝试多种方式获取页面内容，确保能捕获到SPA应用的动态内容
            let pageText = '';
            
            // 方法1：获取body文本内容
            pageText += (document.body.innerText || '').toLowerCase();
            
            // 方法2：获取所有可见元素的文本
            const allElements = document.querySelectorAll('*:not(script):not(style):not(link)');
            allElements.forEach(element => {
              if (element.offsetParent !== null) { // 只获取可见元素
                pageText += ' ' + (element.textContent || element.innerText || '').toLowerCase();
              }
            });
            
            // 方法3：获取标题
            pageText += ' ' + (document.title || '').toLowerCase();
            
            // 方法4：获取URL中的路径和参数，可能包含状态信息
            pageText += ' ' + window.location.href.toLowerCase();
            
            return pageText;
          }
          PaymentStatusChecker.postMessage(getPageContent());
          
          // 2. 检测所有按钮点击，特别是包含支付相关和取消相关文本的按钮
          function detectPaymentButtons() {
            const allButtons = document.querySelectorAll('button, input[type="button"], input[type="submit"], a');
            
            // 定义支付相关关键词
            const paymentKeywords = [
              'pay', 'payment', 'buy', 'purchase', 'checkout', 'confirm',
              'pay now', 'confirm payment', 'submit', 'continue', '完成', '支付', '确认',
              '立即支付', '确认支付', '提交订单', '下单', '付款'
            ];
            
            // 定义取消相关关键词
            const cancelKeywords = [
              'cancel', 'back', 'return', 'abort', 'exit', 'close',
              '取消', '返回', '退出', '关闭', '放弃'
            ];
            
            allButtons.forEach(button => {
              // 检查按钮文本或aria标签
              const buttonText = (button.textContent || button.innerText || button.value || button.getAttribute('aria-label') || '').toLowerCase();
              
              // 检查是否包含支付关键词
              const hasPaymentKeyword = paymentKeywords.some(keyword => buttonText.includes(keyword.toLowerCase()));
              
              // 检查是否包含取消关键词
              const hasCancelKeyword = cancelKeywords.some(keyword => buttonText.includes(keyword.toLowerCase()));
              
              // 检查按钮是否有支付相关的类名或ID
              const hasPaymentClass = button.className && button.className.toLowerCase().match(/pay|payment|checkout|confirm|submit/);
              const hasPaymentId = button.id && button.id.toLowerCase().match(/pay|payment|checkout|confirm|submit/);
              
              // 检查按钮是否有取消相关的类名或ID
              const hasCancelClass = button.className && button.className.toLowerCase().match(/cancel|back|return|abort|exit|close/);
              const hasCancelId = button.id && button.id.toLowerCase().match(/cancel|back|return|abort|exit|close/);
              
              // 检查按钮是否指向支付相关URL
              const hasPaymentHref = button.tagName === 'A' && button.href && 
                (button.href.toLowerCase().includes('pay') || 
                 button.href.toLowerCase().includes('payment') ||
                 button.href.toLowerCase().includes('checkout'));
              
              // 检查按钮是否指向取消相关URL
              const hasCancelHref = button.tagName === 'A' && button.href && 
                (button.href.toLowerCase().includes('cancel') || 
                 button.href.toLowerCase().includes('back') ||
                 button.href.toLowerCase().includes('return') ||
                 button.href.toLowerCase().includes('exit'));
              
              // 如果是支付按钮，添加点击监听
              if (hasPaymentKeyword || hasPaymentClass || hasPaymentId || hasPaymentHref) {
                button.addEventListener('click', function(e) {
                  // 只检测用户主动点击，不检测自动触发的点击
                  if (!e.isTrusted) return; // 过滤掉非用户主动触发的事件
                  PaymentInitiationDetector.postMessage('Payment button clicked: ' + buttonText);
                });
              }
              
              // 如果是取消按钮，添加点击监听
              if (hasCancelKeyword || hasCancelClass || hasCancelId || hasCancelHref) {
                button.addEventListener('click', function(e) {
                  // 只检测用户主动点击，不检测自动触发的点击
                  if (!e.isTrusted) return; // 过滤掉非用户主动触发的事件
                  PaymentInitiationDetector.postMessage('Cancel button clicked: ' + buttonText);
                });
              }
            });
          }
          
          // 3. 监听所有表单提交事件，特别是支付表单
          function detectFormSubmissions() {
            document.addEventListener('submit', function(e) {
              // 只检测用户主动提交，不检测自动提交
              if (!e.isTrusted) return; // 过滤掉非用户主动触发的事件
              
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
          
          // 4. 移除API调用检测，避免误触发
          function detectPaymentApiCalls() {
            // 注释掉API调用检测，因为页面加载时的自动API请求会导致误触发
            // 只保留用户主动操作的检测
          }
          
          // 5. 移除URL变化检测，避免误触发
          function detectPaymentStatusChanges() {
            // 注释掉URL变化检测，因为页面自动跳转可能导致误触发
            // 只保留用户主动操作的检测
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
      _printWithTime(
          "Error checking page content and injecting payment detection: $e");
    }
  }

  // 检查页面内容中是否包含支付完成标识
  void _checkPaymentKeywords(String pageContent) {
    _printWithTime("检测页面内容，原始文件为: $pageContent");

    // 转换为小写，统一比较
    pageContent = pageContent.toLowerCase();

    // 检查URL是否包含支付完成标识（2C2P支付完成页面URL包含/info/路径）
    if (pageContent.contains('/info/')) {
      _printWithTime("检测到支付完成页面: URL包含/info/路径");
      _stopSdkPolling(); // 停止SDK轮询

      // 检查是否已取消支付
      if (_isPaymentCancelled) {
        _printWithTime("已检测到支付取消，不返回orderId，不触发轮询");
        Get.back(result: null);
        return;
      }

      _printWithTime("退出WebView，返回订单支付页面，通过服务器接口轮询支付状态");

      // 安全获取orderId
      String orderId = "";
      try {
        final arguments = Get.arguments ?? {};
        orderId = arguments["orderId"] ?? "";
      } catch (e) {
        _printWithTime("获取orderId失败: $e");
        orderId = "";
      }
      _printWithTime("订单${orderId}返回支付页面");

      // 返回orderId，触发服务器接口轮询
      Get.back(result: orderId.isNotEmpty ? orderId : null);
      return;
    }

    _printWithTime("未检测到支付完成页面，继续在WebView中处理");
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
            _printWithTime(
                "User is exiting webview, returning to payment page");
            // 停止SDK轮询
            _stopSdkPolling();
            // 获取orderId
            String orderId = "";
            try {
              final arguments = Get.arguments ?? {};
              orderId = arguments["orderId"] ?? "";
            } catch (e) {
              _printWithTime("Error getting orderId: $e");
              orderId = "";
            }

            // 打印调试信息
            _printWithTime("Payment initiated: $_isPaymentInitiated");
            _printWithTime("Payment cancelled: $_isPaymentCancelled");
            _printWithTime("Order ID: $orderId");

            // 只有当用户真正发起了支付请求且未取消支付时，才返回orderId进行轮询
            // 如果用户点击了取消按钮，返回null，不需要轮询订单状态
            bool shouldPoll = _isPaymentInitiated &&
                !_isPaymentCancelled &&
                orderId.isNotEmpty;
            _printWithTime("Should poll: $shouldPoll");

            Get.back(result: shouldPoll ? orderId : null);
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
                  _printWithTime(
                      "User is exiting webview via app bar button, returning to payment page");
                  // 停止SDK轮询
                  _stopSdkPolling();
                  // 获取orderId
                  String orderId = "";
                  try {
                    final arguments = Get.arguments ?? {};
                    orderId = arguments["orderId"] ?? "";
                  } catch (e) {
                    _printWithTime("Error getting orderId: $e");
                    orderId = "";
                  }

                  // 打印调试信息
                  _printWithTime("Payment initiated: $_isPaymentInitiated");
                  _printWithTime("Payment cancelled: $_isPaymentCancelled");
                  _printWithTime("Order ID: $orderId");

                  // 只有当用户真正发起了支付请求且未取消支付时，才返回orderId进行轮询
                  // 如果用户点击了取消按钮，返回null，不需要轮询订单状态
                  bool shouldPoll = _isPaymentInitiated &&
                      !_isPaymentCancelled &&
                      orderId.isNotEmpty;
                  _printWithTime("Should poll: $shouldPoll");

                  Get.back(result: shouldPoll ? orderId : null);
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
      _printWithTime("Error getting orderId: $e");
      orderId = "";
    }

    _printWithTime("-----------------------queryTransaction orderId:$orderId");
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
    _printWithTime(
        "SDK Polling - Attempt $_sdkPollingAttempts/200 for paymentToken: $paymentToken");

    //Step 3: Retrieve transaction status inquiry response.
    PGWSDK().transactionStatus(request, (response) {
      _printWithTime(
          "-----------sdk检测开始，response code:${response['responseCode']}");
      if (response['responseCode'] == APIResponseCode.transactionCompleted) {
        // Payment successful
        _printWithTime("SDK检测到支付成功");
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
        _printWithTime("SDK Polling timed out after 200 attempts");
      }
      // 其他状态，继续轮询
    }, (error) {
      // API call failed
      if (_sdkPollingAttempts >= 200) {
        // 轮询达到最大次数，停止轮询
        _stopSdkPolling();
        dismissLoading();
        _printWithTime(
            "SDK Polling timed out after 200 attempts due to API error");
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
    _printWithTime("SDK Polling stopped");
  }
}
