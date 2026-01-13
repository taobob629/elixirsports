import 'package:elixir_esports/api/wallet_api.dart';
import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/ui/pages/order/new_order_detail_page.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../widget/my_button_widget.dart';
import '../widget/pay_method_widget.dart';
import '../pages/order/order_detail_page.dart';
import '../pages/order/order_list_page.dart';
import '../pages/wallet/pgw_webview_page.dart';

// 导入目标页面（根据你项目的实际路径调整）
import 'package:elixir_esports/ui/pages/main/scan/my_qr_code_page.dart';

// 封装金额格式化工具函数（全局/单独封装均可）
String formatAmount(double amount) {
  return amount.toStringAsFixed(2); // 保留2位小数，符合金额显示规范
}

class ScanOrderPaymentDialog extends StatefulWidget {
  /// 优惠卷ID（0表示无优惠）
  final String couponId;

  /// 订单ID（必填）
  final String orderId;

  /// 实际支付金额（必填，≥0）
  final double payAmount;

  /// 折扣金额（必填，≥0）
  final double discountAmount;

  /// 支付成功回调
  final Function()? onPaymentSuccess;

  const ScanOrderPaymentDialog({
    super.key,
    required this.orderId,
    required this.couponId,
    required this.discountAmount,
    required this.payAmount,
    this.onPaymentSuccess,
  })  :
        // 参数校验：防止传入非法值
        assert(payAmount >= 0, "支付金额不能为负数"),
        assert(discountAmount >= 0, "折扣金额不能为负数");

  @override
  State<ScanOrderPaymentDialog> createState() => _ScanOrderPaymentDialogState();
}

class _ScanOrderPaymentDialogState extends State<ScanOrderPaymentDialog>
    with SingleTickerProviderStateMixin {
  // 支付方式：4：支付宝 5：微信  8：PayNow,2:balance 9：银行卡
  final RxInt payMethod = 2.obs;

  // 动画相关
  late AnimationController _animationController;
  late Animation<double> _discountAnimation;
  double _currentAnimatedValue = 0.0; // 初始值为0，保证从0开始动画

  @override
  void initState() {
    super.initState();
    // 初始化动画控制器（800ms 平滑动画）
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // 启动折扣金额动画（从0到目标折扣值）
    _startDiscountAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 启动折扣金额动画：从0平滑增长到目标折扣值
  void _startDiscountAnimation() {
    // 重置动画状态
    _animationController.reset();

    // 定义从0到目标折扣值的动画
    _discountAnimation = Tween<double>(
      begin: 0.0, // 固定从0开始
      end: widget.discountAmount,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut, // 先快后慢，动画更自然
      ),
    );

    // 监听动画值变化，更新UI
    _discountAnimation.addListener(() {
      setState(() {
        _currentAnimatedValue = _discountAnimation.value;
      });
    });

    // 只有当折扣金额>0时才启动动画（避免无意义动画）
    if (widget.discountAmount > 0) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 1.sw,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题+取消按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PAYMENT'.tr,
                    style: TextStyle(
                      color: toColor('#3D3D3D'),
                      fontSize: 15.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => _dismissDialog(), // 统一关闭逻辑
                    child: Text(
                      'CANCEL'.tr,
                      style: TextStyle(
                        color: toColor('#767676'),
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ),
                ],
              ),

              // 实际支付金额
              RichText(
                text: TextSpan(
                  text: "S\$",
                  style: TextStyle(
                    color: toColor('#333333'),
                    fontFamily: FONT_MEDIUM,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: formatAmount(widget.payAmount), // 格式化支付金额
                      style: TextStyle(fontSize: 36.sp),
                    ),
                  ],
                ),
              ).marginOnly(top: 12.h),
              Text(
                "Payment Amount".tr,
                style: TextStyle(
                  color: toColor('#767676'),
                  fontFamily: FONT_MEDIUM,
                  fontSize: 13.sp,
                ),
              ).paddingOnly(top: 10.h, bottom: 20.h),

              // 折扣金额（带动画）：仅当折扣>0时显示
              Visibility(
                visible: widget.discountAmount > 0, // 无折扣时隐藏
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount'.tr,
                      style: TextStyle(
                        color: toColor('#333333'),
                        fontSize: 13.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: '-S\$',
                        style: TextStyle(
                          color: toColor('#EA0000'),
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            // 格式化动画数值，保留2位小数
                            text: formatAmount(_currentAnimatedValue),
                            style: TextStyle(
                              color: toColor('#EA0000'),
                              fontSize: 20.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).paddingOnly(bottom: 20.h),

              // 支付方式选择
              Obx(() => PayMethodWidget(
                    name: "Elixirs".tr,
                    icon: SvgPicture.asset(
                      AssetsUtils.icon_balance,
                      width: 20.w,
                      height: 20.w,
                    ),
                    isSelect: payMethod.value == 2,
                    callback: () => payMethod.value = 2,
                  )),
              _divider(),
              Obx(() => PayMethodWidget(
                    name: "Alipay".tr,
                    icon: SvgPicture.asset(
                      AssetsUtils.icon_alipay,
                      width: 20.w,
                      height: 20.w,
                    ),
                    isSelect: payMethod.value == 4,
                    callback: () => payMethod.value = 4,
                  )),
              _divider(),
              Obx(() => PayMethodWidget(
                    name: "Wechat Pay".tr,
                    icon: Image.asset(
                      "assets/images/icon_wechat.png",
                      width: 20.w,
                      height: 20.w,
                    ),
                    isSelect: payMethod.value == 5,
                    callback: () => payMethod.value = 5,
                  )),
              _divider(),
              Obx(() => PayMethodWidget(
                    name: "PayNow".tr,
                    icon: Image.asset(
                      "assets/images/icon_paynow.png",
                      width: 20.w,
                      height: 20.w,
                    ),
                    isSelect: payMethod.value == 8,
                    callback: () => payMethod.value = 8,
                  )),

              // 支付按钮
              MyButtonWidget(
                btnText: "PAYMENT".tr,
                marginBottom: 10.h,
                onTap: _handlePay,
              ),
            ],
          ),
        ),
      );

  /// 分割线封装（简化代码）
  Widget _divider() {
    return Container(
      height: 1.h,
      color: toColor('#EEEEEE'),
      margin: EdgeInsets.symmetric(vertical: 14.h),
    );
  }

  /// 统一关闭弹窗逻辑
  void _dismissDialog() {
    SmartDialog.dismiss(status: SmartStatus.allDialog);
    Get.back();
  }

  /// 启动checkOrderState接口轮询
  Future<void> _startCheckOrderStatePolling(String orderId) async {
    // 设置轮询参数
    const int intervalSeconds = 2; // 每2秒轮询一次
    const int maxAttempts = 100; // 最多轮询100次
    int attempts = 0;
    Timer? pollingTimer;
    bool _isPollingCancelled = false;
    bool _isPaymentProcessed = false; // 标记支付是否已处理（成功或失败）

    try {
      // 显示带取消按钮的加载对话框 - 只显示一次，点击遮罩不关闭
      SmartDialog.show(
        builder: (context) => Container(
          width: 300.w,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.r,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Text(
                "Checking payment status".tr,
                style: TextStyle(
                  color: toColor("#3d3d3d"),
                  fontFamily: FONT_MEDIUM,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),

              // 进度指示器
              CircularProgressIndicator(
                color: toColor("#1890ff"),
                strokeWidth: 3.w,
              ),
              SizedBox(height: 20.h),

              // 提示文字
              Text(
                "Please wait while we check your payment status.".tr,
                style: TextStyle(
                  color: toColor("#666666"),
                  fontFamily: FONT_MEDIUM,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // 取消按钮
              SizedBox(
                width: double.infinity,
                child: MyButtonWidget(
                  btnText: "Cancel".tr,
                  onTap: () {
                    // 用户主动取消轮询，只关闭轮询等待弹窗，不关闭支付弹窗
                    _isPollingCancelled = true;
                    _isPaymentProcessed = true;
                    pollingTimer?.cancel();
                    SmartDialog.dismiss(); // 只关闭轮询等待弹窗
                    showInfo("Payment check cancelled. Please try again or check your order status later."
                        .tr); // 给出取消提示
                  },
                  height: 45.h,
                  marginBottom: 0.h,
                ),
              ),
            ],
          ),
        ),
        useSystem: false,
        clickMaskDismiss: false, // 点击遮罩不关闭对话框
      );

      // 立即执行第一次轮询
      attempts++;
      debugPrint(
          'Checking order state - Attempt $attempts/$maxAttempts for orderId: $orderId');

      try {
        // 调用checkOrderState接口
        final result = await WalletApi.checkOrderState(orderId: orderId);

        if (result != null && !_isPollingCancelled && !_isPaymentProcessed) {
          debugPrint('checkOrderState response: $result');

          if (result['state'] == 1) {
            // 支付成功，停止轮询
            debugPrint('Payment successful! OrderId: $orderId, State: 1');
            _isPaymentProcessed = true;
            SmartDialog.dismiss();

            _dismissDialog(); // 关闭支付弹窗
            showSuccess("Payment successfully".tr);

            // 调用支付成功回调
            if (widget.onPaymentSuccess != null) {
              widget.onPaymentSuccess!();
            }
            return; // 直接返回，不启动定时器
          } else if (result['state'] == 0) {
            // 支付中，继续轮询
            debugPrint('Payment in progress. OrderId: $orderId, State: 0');
          } else if (result['state'] == 2) {
            // 支付失败，停止轮询
            debugPrint('Payment failed! OrderId: $orderId, State: 2');
            _isPaymentProcessed = true;
            SmartDialog.dismiss();
            // 不关闭支付弹窗，停留在订单页面
            showInfo("Payment failed".tr);
            return; // 直接返回，不启动定时器
          } else {
            // 其他状态，支付失败或异常
            debugPrint('Payment failed with unknown state: ${result['state']}');
            _isPaymentProcessed = true;
            SmartDialog.dismiss();
            // 不关闭支付弹窗，停留在订单页面
            showInfo("Payment failed. Please try again or check your order status.".tr);
            return; // 直接返回，不启动定时器
          }
        }
      } catch (e) {
        debugPrint('Error in checkOrderState polling: $e');
      }

      // 检查是否达到最大尝试次数
      if (attempts >= maxAttempts) {
        debugPrint('Polling reached maximum attempts ($maxAttempts), stopping');
        _isPaymentProcessed = true;
        SmartDialog.dismiss();
        // 不关闭支付弹窗，停留在订单页面
        showInfo(
            "Check order status timeout. Please try again or check your order status later."
                .tr);
        return;
      }

      // 如果第一次轮询没有完成（状态不是1且未取消），启动定时器继续轮询
      if (!_isPollingCancelled && !_isPaymentProcessed) {
        pollingTimer =
            Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
          // 检查状态，避免重复执行
          if (_isPollingCancelled || _isPaymentProcessed) {
            timer.cancel();
            return;
          }

          attempts++;
          debugPrint(
              'Checking order state - Attempt $attempts/$maxAttempts for orderId: $orderId');

          // 检查是否达到最大尝试次数
          if (attempts >= maxAttempts) {
            debugPrint(
                'Polling reached maximum attempts ($maxAttempts), stopping');
            _isPaymentProcessed = true;
            timer.cancel();
            SmartDialog.dismiss();
            // 不关闭支付弹窗，停留在订单页面
            showInfo(
                "Check order status timeout. Please try again or check your order status later."
                    .tr);
            return;
          }

          try {
            // 调用checkOrderState接口
            final result = await WalletApi.checkOrderState(orderId: orderId);

            if (result != null &&
                !_isPollingCancelled &&
                !_isPaymentProcessed) {
              debugPrint('checkOrderState response: $result');

              if (result['state'] == 1) {
                // 支付成功，停止轮询
                debugPrint('Payment successful! OrderId: $orderId, State: 1');
                _isPaymentProcessed = true;
                timer.cancel();
                SmartDialog.dismiss();

                _dismissDialog(); // 关闭支付弹窗
                showSuccess("Payment successfully".tr);

                // 调用支付成功回调
                if (widget.onPaymentSuccess != null) {
                  widget.onPaymentSuccess!();
                }
              } else if (result['state'] == 0) {
                // 支付中，继续轮询
                debugPrint('Payment in progress. OrderId: $orderId, State: 0');
              } else if (result['state'] == 2) {
                // 支付失败，停止轮询
                debugPrint('Payment failed! OrderId: $orderId, State: 2');
                _isPaymentProcessed = true;
                timer.cancel();
                SmartDialog.dismiss();
                // 不关闭支付弹窗，停留在订单页面
                showInfo("Payment failed".tr);
              } else {
                // 其他状态，支付失败或异常
                debugPrint(
                    'Payment failed with unknown state: ${result['state']}');
                _isPaymentProcessed = true;
                timer.cancel();
                SmartDialog.dismiss();
                // 不关闭支付弹窗，停留在订单页面
                showInfo(
                    "Payment failed. Please try again or check your order status."
                        .tr);
              }
            }
          } catch (e) {
            debugPrint('Error in checkOrderState polling: $e');
            // 网络错误，继续轮询，直到达到最大尝试次数
          }
        });
      }
    } catch (e) {
      debugPrint('Error starting polling: $e');
      _isPaymentProcessed = true;
      pollingTimer?.cancel();
      SmartDialog.dismiss();
      _dismissDialog(); // 关闭支付弹窗
      showInfo("Error starting payment status check. Please try again.".tr);
    }
  }

  /// 处理支付点击事件
  void _handlePay() async {
    // 关闭加载弹窗（防止重复显示）
    SmartDialog.dismiss(status: SmartStatus.loading);

    // 校验支付方式
    if (payMethod.value == 0) {
      showToast("Please select a payment method".tr);
      return;
    }
    if (payMethod.value == 2) {
      await _balancePay();
    } else {
      await _thirdPay();
    }
  }

  Future<void> _balancePay() async {
    try {
      SmartDialog.showLoading(msg: "Processing payment...".tr);

      // 构造请求参数
      final Map<String, dynamic> map = {
        "couponId": widget.couponId,
        "orderId": widget.orderId,
        "way": payMethod.value, // 4:支付宝 5:微信 8:PayNow
      };

      // 调用支付接口
      final result = await WalletApi.balancePay(map: map);

      if (result!.state) {
        _dismissDialog(); // 关闭支付弹窗
        showSuccess("Payment successfully".tr);
        // 调用支付成功回调，用于导航到订单列表
        if (widget.onPaymentSuccess != null) {
          widget.onPaymentSuccess!();
        }
      } else {
        showInfo(result!.msg);
      }
    } catch (e) {
      debugPrint('Payment error: $e');
      showInfo("Payment failed5".tr);
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  /// 调用第三方支付
  Future<void> _thirdPay() async {
    try {
      SmartDialog.showLoading(msg: "Processing payment...".tr);

      // 构造请求参数
      final Map<String, dynamic> map = {
        "couponId": widget.couponId,
        "orderId": widget.orderId,
        "way": payMethod.value, // 4:支付宝 5:微信 8:PayNow
      };

      // 调用支付接口
      final pgwModel =
          await WalletApi.getPGWPaymentTokenAndUrlScanPay(map: map);

      debugPrint('pgwModel?.webPaymentUrl: ${pgwModel?.webPaymentUrl}');
      debugPrint('pgwModel?.paymentToken: ${pgwModel?.paymentToken}');
      debugPrint('pgwModel?.invoiceNo: ${pgwModel?.invoiceNo}');
      debugPrint('widget.orderId: ${widget.orderId}');

      // 校验并使用内置WebView打开支付链接
      if (pgwModel?.webPaymentUrl != null &&
          pgwModel!.webPaymentUrl.isNotEmpty) {
        // 使用内置WebView进行支付，添加跳转目标参数
        final result = await Get.to(() => PGWWebViewPage(), arguments: {
          "url": pgwModel.webPaymentUrl,
          "paymentToken": pgwModel.paymentToken,
          "orderId": widget.orderId,
          "redirectTarget": "orderList" // 默认跳转到订单列表
        });

        // 根据WebView返回结果处理
        if (result == true) {
          // 支付成功（SDK轮询检测到）
          _dismissDialog();
          showSuccess("Payment successfully".tr);
          // 调用支付成功回调
          if (widget.onPaymentSuccess != null) {
            widget.onPaymentSuccess!();
          }
        } else if (result is String && result.isNotEmpty) {
          // 从webview返回orderId，需要轮询checkOrderState接口
          String returnedOrderId = result;
          debugPrint(
              'WebView returned orderId: $returnedOrderId, starting checkOrderState polling');

          // 启动轮询checkOrderState接口
          await _startCheckOrderStatePolling(returnedOrderId);
        } else {
          // 支付失败或取消
          showSuccess("Payment failed6".tr);
        }
      } else {
        showInfo("Payment failed7".tr);
      }
    } catch (e) {
      debugPrint('Payment error: $e');
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }
}
