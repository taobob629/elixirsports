import 'package:elixir_esports/api/wallet_api.dart';
import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/ui/pages/order/new_order_detail_page.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
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

  const ScanOrderPaymentDialog({
    super.key,
    required this.orderId,
    required this.couponId,
    required this.discountAmount,
    required this.payAmount,
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

  /// 处理支付点击事件
  void _handlePay() async {
    // 关闭加载弹窗（防止重复显示）
    SmartDialog.dismiss(status: SmartStatus.loading);

    // 校验支付方式
    if (payMethod.value == 0) {
      showToast("Please select a payment method".tr);
      return;
    }
    if (payMethod == 2) {
      await _balancePay();
    } else {
      await _thirdPay();
    }

    // 支付成功后跳转到订单列表页面，而不是订单详情页面
    Get.offAll(() => OrderListPage());
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

        // 支付成功后跳转到订单列表页面，而不是订单详情页面
        Get.offAll(() => OrderListPage());
      } else {
        showError(result!.msg);
      }
    } catch (e) {
      debugPrint('Payment error: $e');
      showError("Payment failed".tr);
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

      // 校验并打开支付链接
      if (pgwModel?.webPaymentUrl != null &&
          pgwModel!.webPaymentUrl.isNotEmpty) {
        if (await canLaunchUrlString(pgwModel.webPaymentUrl)) {
          await launchUrlString(
            pgwModel.webPaymentUrl,
            mode: LaunchMode.externalApplication, // 跳转到外部浏览器/支付APP
          );
          _dismissDialog(); // 关闭支付弹窗
        } else {
          throw Exception("Cannot launch payment URL");
        }
      } else {
        throw Exception("Payment URL is null or empty");
      }
    } catch (e) {
      debugPrint('Payment error: $e');
      showError("Payment failed".tr);
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }
}
