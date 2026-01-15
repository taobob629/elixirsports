import 'package:elixir_esports/api/wallet_api.dart';
import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/getx_ctr/wallet_ctr.dart';
import 'package:elixir_esports/ui/pages/banks/bank_cards_page.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';

import '../../models/coupon_list_model.dart';
import '../../models/wallet_model.dart';
import '../widget/dashed_line_widget.dart';
import '../widget/my_button_widget.dart';
import '../widget/pay_method_widget.dart';
import '../pages/wallet/pgw_webview_page.dart';

class TopUpConfirmDialog extends StatefulWidget {
  int money = 0;
  int type = 0;

  // type  充值0 金卡5 砖石10  高级15
  TopUpConfirmDialog({
    super.key,
    required this.money,
    required this.type,
  });

  @override
  State<TopUpConfirmDialog> createState() => _TopUpConfirmDialogState();
}

class _TopUpConfirmDialogState extends State<TopUpConfirmDialog>
    with SingleTickerProviderStateMixin {
  var showCoupon = false.obs;
  var currentSelectIndex = (-1).obs;
  var couponList = <CouponsRow>[].obs;
  var discount = 0.obs; // 目标折扣值
  var cardNo = "".obs;

  // 支付方式：9：银行卡 4：支付宝 5：微信  8：PayNow
  var payMethod = 4.obs;

  // 动画相关
  late AnimationController _animationController;
  late Animation<int> _discountAnimation;
  int _currentAnimatedValue = 0; // 当前动画显示的数值

  // 轮询相关变量
  Timer? _pollingTimer;
  bool _isPollingCancelled = false;
  bool _isPaymentProcessed = false;
  int _pollingAttempts = 0;
  final int _maxPollingAttempts = 20;
  final int _pollingIntervalSeconds = 5;

  @override
  void initState() {
    super.initState();
    getCouponList();

    // 初始化动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // 动画时长，可调整
    );

    // 监听discount值变化，触发动画
    ever(discount, (newValue) {
      _startNumberAnimation(newValue);
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // 释放动画资源
    super.dispose();
  }

  // 启动数字增长动画
  void _startNumberAnimation(int targetValue) {
    // 重置动画
    _animationController.reset();

    // 创建从当前值到目标值的动画
    _discountAnimation = IntTween(
      begin: _currentAnimatedValue,
      end: targetValue,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut, // 动画曲线，easeOut让动画先快后慢
      ),
    );

    // 监听动画值变化，更新当前显示值
    _discountAnimation.addListener(() {
      setState(() {
        _currentAnimatedValue = _discountAnimation.value;
      });
    });

    // 启动动画
    _animationController.forward();
  }

  void getCouponList() async {
    couponList.value = await WalletApi.topUpCoupons(amount: widget.money);
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
                    onTap: () => dismissLoading(),
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
                      text: widget.money.toString(),
                      style: TextStyle(
                        fontSize: 36.sp,
                      ),
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
              Visibility(
                visible: widget.type == 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reward'.tr,
                      style: TextStyle(
                        color: toColor('#333333'),
                        fontSize: 13.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 静态文本 + 动画数字
                    Text.rich(
                      TextSpan(
                        // 静态部分：+S$
                        text: '+S\$',
                        style: TextStyle(
                          color: toColor('#EA0000'),
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                        ),
                        // 动画数字部分
                        children: [
                          TextSpan(
                            text: '$_currentAnimatedValue',
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
              ),
              Visibility(
                visible: widget.type == 0,
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 32.h, bottom: 20.h),
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 19.w,
                      top: 17.h,
                      bottom: 17.h,
                    ),
                    decoration: BoxDecoration(
                      color: toColor('#F0F6F9'),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => showCoupon.value = !showCoupon.value,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetsUtils.icon_coupon,
                                width: 20.w,
                              ),
                              Expanded(
                                child: Text(
                                  "COUPON".tr,
                                  style: TextStyle(
                                    color: toColor('#1A1A1A'),
                                    fontFamily: FONT_MEDIUM,
                                    fontSize: 13.sp,
                                  ),
                                ).paddingOnly(left: 10.w),
                              ),
                              Obx(() => RichText(
                                    text: TextSpan(
                                      text: "Quantity：".tr,
                                      style: TextStyle(
                                        color: toColor('#333333'),
                                        fontFamily: FONT_MEDIUM,
                                        fontSize: 13.sp,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              "${couponList.where((item) => item.available == 1).length}",
                                          style: TextStyle(
                                              color: toColor('#EA0000')),
                                        ),
                                      ],
                                    ),
                                  )),
                              Obx(() => Icon(
                                    showCoupon.value
                                        ? Icons.keyboard_arrow_down_outlined
                                        : Icons.keyboard_arrow_right_outlined,
                                    size: 28.sp,
                                    color: toColor('#42494F'),
                                  ).marginOnly(left: 13.w)),
                            ],
                          ),
                        ),
                        Obx(() => Visibility(
                              visible: showCoupon.value,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 0.35.sh,
                                ),
                                margin: EdgeInsets.only(top: 15.h),
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (c, i) =>
                                      itemWidget(couponList[i], i),
                                  separatorBuilder: (c, i) => Divider(
                                    height: 0.5.h,
                                    color: toColor('#D4E4E4'),
                                  ),
                                  itemCount: couponList.length,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
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
              Container(
                height: 1.h,
                color: toColor('#EEEEEE'),
                margin: EdgeInsets.symmetric(
                  vertical: 14.h,
                ),
              ),
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
              Container(
                height: 1.h,
                color: toColor('#EEEEEE'),
                margin: EdgeInsets.symmetric(
                  vertical: 14.h,
                ),
              ),
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
              Container(
                height: 1.h,
                color: toColor('#EEEEEE'),
                margin: EdgeInsets.symmetric(
                  vertical: 14.h,
                ),
              ),
              MyButtonWidget(
                btnText: "PAYMENT".tr,
                marginBottom: 10.h,
                onTap: topUp,
              ),
            ],
          ),
        ),
      );

  Widget itemWidget(CouponsRow item, int i) => InkWell(
        onTap: () => calculateCoupons(item, i),
        child: Column(
          children: [
            SizedBox(
              height: 120.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0.w,
                    right: 0.w,
                    child: item.available == 0
                        ? SvgPicture.asset(
                            item.couponType == 3 || item.couponType == 5
                                ? AssetsUtils.coupon_red_bg
                                : item.couponType == 8
                                    ? AssetsUtils.coupon_lan_bg
                                    : AssetsUtils.coupon_lv_bg,
                            height: 120.h,
                            fit: BoxFit.fill,
                            color: Colors.grey,
                          )
                        : SvgPicture.asset(
                            item.couponType == 3 || item.couponType == 5
                                ? AssetsUtils.coupon_red_bg
                                : item.couponType == 8
                                    ? AssetsUtils.coupon_lan_bg
                                    : AssetsUtils.coupon_lv_bg,
                            height: 120.h,
                            fit: BoxFit.fill,
                          ),
                  ),
                  Positioned(
                    left: 15.w,
                    top: 15.h,
                    child: Text(
                      "${item.name}",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: FONT_MEDIUM,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.note ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FONT_MEDIUM,
                            fontSize: 11.sp,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        '${item.value}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FONT_MEDIUM,
                          fontSize: 20.sp,
                        ),
                      ),
                      Text(
                        '${item.unit}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FONT_MEDIUM,
                          fontSize: 11.sp,
                        ),
                      ).paddingOnly(left: 2.w, top: 6.h),
                    ],
                  ).marginOnly(top: 37.h, left: 15.w, right: 15.w),
                  DashedLineWidget()
                      .marginOnly(top: 80.h, left: 15.w, right: 15.w),
                  Positioned(
                    bottom: 12.h,
                    left: 15.w,
                    child: RichText(
                      text: TextSpan(
                        text: 'Validity period:'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                        children: [
                          TextSpan(text: (item.expireTime ?? '').split(" ")[0])
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Obx(() => currentSelectIndex.value != i
                    ? Icon(
                        Icons.circle_outlined,
                        size: 18.w,
                        color: item.available == 0
                            ? Colors.grey
                            : toColor('#3D3D3D'),
                      )
                    : Icon(
                        Icons.check_circle,
                        size: 18.w,
                        color: Colors.red,
                      )),
                Text(
                  "Use This Coupon".tr,
                  style: TextStyle(
                    color:
                        item.available == 0 ? Colors.grey : toColor('#3D3D3D'),
                    fontFamily: FONT_MEDIUM,
                    fontSize: 13.sp,
                  ),
                ).paddingOnly(left: 8.w),
              ],
            ).marginSymmetric(vertical: 10.h),
            Divider(
              color: toColor('#D4E4E4'),
              height: 1.h,
            ).marginOnly(bottom: 12.h),
          ],
        ),
      );

  void calculateCoupons(CouponsRow item, int i) async {
    if (item.available == 1) {
      if (currentSelectIndex.value == i) {
        // 取消选择优惠券，数字从当前值减到0
        discount.value = 0;
        currentSelectIndex.value = -1;
      } else {
        currentSelectIndex.value = i;
        // 获取目标折扣值
        int newDiscount = await WalletApi.calculateCoupons(
          voucherId: item.id,
          amount: widget.money,
        );
        // 更新目标值，触发动画
        discount.value = newDiscount;
        showCoupon.value = false;
      }
    }
  }

  /// 启动checkOrderState接口轮询
  Future<void> _startCheckOrderStatePolling(String orderId) async {
    // 重置轮询状态
    _pollingAttempts = 0;
    _isPollingCancelled = false;
    _isPaymentProcessed = false;
    ('PollingStart', 'Starting checkOrderState polling', orderId: orderId);

    // 显示带取消按钮的加载对话框 - 只显示一次，点击遮罩不关闭，按系统回退键也不关闭
    SmartDialog.show(
      builder: (context) => WillPopScope(
        onWillPop: () async {
          // 拦截系统回退键，阻止关闭对话框和停止轮询
          (
            'BackButtonBlocked',
            'System back button blocked during payment polling',
            orderId: orderId
          );
          return false; // 返回false阻止回退
        },
        child: Container(
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
                    // 用户主动取消轮询，只关闭轮询对话框
                    (
                      'PollingCancelled',
                      'User cancelled payment polling',
                      orderId: orderId
                    );
                    _isPollingCancelled = true;
                    _isPaymentProcessed = true;
                    _pollingTimer?.cancel();
                    SmartDialog.dismiss(); // 关闭轮询等待弹窗
                    // 不关闭支付弹窗，让用户自行决定后续操作
                  },
                  height: 45.h,
                  marginBottom: 0.h,
                ),
              ),
            ],
          ),
        ),
      ),
      useSystem: false,
      clickMaskDismiss: false, // 点击遮罩不关闭对话框
      backType: SmartBackType.block, // 阻止系统回退键关闭对话框
    );

    // 立即执行第一次轮询
    _pollingAttempts++;
    (
      'PollingAttempt',
      'Attempt $_pollingAttempts/$_maxPollingAttempts',
      orderId: orderId
    );

    try {
      // 调用checkOrderState接口
      ('ApiCall', 'Calling checkOrderState API', orderId: orderId);
      final result = await WalletApi.checkTopUpOrderState(orderId: orderId);
      ('ApiResponse', 'checkOrderState response: $result', orderId: orderId);

      if (result != null && !_isPollingCancelled && !_isPaymentProcessed) {
        if (result['state'] == 1) {
          // 支付成功，停止轮询
          ('PaymentSuccess', 'Payment successful! State: 1', orderId: orderId);
          _isPaymentProcessed = true;
          SmartDialog.dismiss();

          // 关闭支付弹窗
          Get.back();
          showSuccess("Payment successfully".tr);
          return; // 直接返回，不启动定时器
        } else if (result['state'] == 0) {
          // 支付中，继续轮询
          (
            'PaymentProcessing',
            'Payment in progress. State: 0',
            orderId: orderId
          );
        } else if (result['state'] == 2) {
          // 支付失败，停止轮询
          ('PaymentFailed', 'Payment failed! State: 2', orderId: orderId);
          _isPaymentProcessed = true;
          SmartDialog.dismiss();
          // 不关闭支付弹窗，停留在充值页面
          showInfo("Payment failed".tr);
          return; // 直接返回，不启动定时器
        } else {
          // 其他状态，支付失败或异常
          (
            'PaymentUnknownState',
            'Payment failed with unknown state: ${result['state']}',
            orderId: orderId
          );
          _isPaymentProcessed = true;
          SmartDialog.dismiss();
          // 不关闭支付弹窗，停留在充值页面
          showInfo(
              "Payment failed. Please try again or check your order status."
                  .tr);
          return; // 直接返回，不启动定时器
        }
      }
    } catch (e, stackTrace) {

    }

    // 检查是否达到最大尝试次数
    if (_pollingAttempts >= _maxPollingAttempts) {
      (
        'PollingTimeout',
        'Polling reached maximum attempts ($_maxPollingAttempts), stopping',
        orderId: orderId
      );
      _isPaymentProcessed = true;
      SmartDialog.dismiss();
      // 不关闭支付弹窗，停留在充值页面
      showInfo(
          "Check order status timeout. Please try again or check your order status later."
              .tr);
      return;
    }

    // 如果第一次轮询没有完成（状态不是1且未取消），启动定时器继续轮询
    if (!_isPollingCancelled && !_isPaymentProcessed) {
      ('PollingTimerStart', 'Starting polling timer', orderId: orderId);
      _pollingTimer = Timer.periodic(Duration(seconds: _pollingIntervalSeconds),
          (timer) async {
        // 检查状态，避免重复执行
        if (_isPollingCancelled || _isPaymentProcessed) {
          timer.cancel();
          ('PollingTimerStop', 'Polling timer stopped', orderId: orderId);
          return;
        }

        _pollingAttempts++;
        (
          'PollingAttempt',
          'Attempt $_pollingAttempts/$_maxPollingAttempts',
          orderId: orderId
        );

        // 检查是否达到最大尝试次数
        if (_pollingAttempts >= _maxPollingAttempts) {
          (
            'PollingTimeout',
            'Polling reached maximum attempts ($_maxPollingAttempts), stopping',
            orderId: orderId
          );
          _isPaymentProcessed = true;
          SmartDialog.dismiss();
          // 不关闭支付弹窗，停留在充值页面
          showInfo(
              "Check order status timeout. Please try again or check your order status later."
                  .tr);
          timer.cancel();
          return;
        }

        try {
          // 调用checkOrderState接口
          final result = await WalletApi.checkTopUpOrderState(orderId: orderId);
          (
            'ApiResponse',
            'checkOrderState response: $result',
            orderId: orderId
          );

          if (result != null && !_isPollingCancelled && !_isPaymentProcessed) {
            if (result['state'] == 1) {
              // 支付成功，停止轮询
              (
                'PaymentSuccess',
                'Payment successful! State: 1',
                orderId: orderId
              );
              _isPaymentProcessed = true;
              timer.cancel();
              SmartDialog.dismiss();

              // 获取充值金额和奖励金
              int money = result['money'] ?? 0;
              int point = result['point'] ?? 0;
              (
                'PaymentAmounts',
                'Received money: $money, point: $point',
                orderId: orderId
              );

              // 更新WalletModel，增加相应的金额
              if (money > 0 || point > 0) {
                WalletCtr walletCtr = Get.find<WalletCtr>();

                // 获取当前金额
                String currentCash = walletCtr.walletModel.value.cash;
                String currentReward = walletCtr.walletModel.value.reward;

                // 转换为数值并增加
                double cashValue = double.tryParse(currentCash) ?? 0.0;
                double rewardValue = double.tryParse(currentReward) ?? 0.0;

                cashValue += money;
                rewardValue += point;

                // 更新walletModel，使用新的数值，移除原有动画效果
                walletCtr.walletModel.value = WalletModel(
                  cash: cashValue.toStringAsFixed(2),
                  reward: rewardValue.toStringAsFixed(2),
                  memberCode: walletCtr.walletModel.value.memberCode,
                  phone: walletCtr.walletModel.value.phone,
                  level: walletCtr.walletModel.value.level,
                  nickName: walletCtr.walletModel.value.nickName,
                  sex: walletCtr.walletModel.value.sex,
                  id: walletCtr.walletModel.value.id,
                  userType: walletCtr.walletModel.value.userType,
                  avatar: walletCtr.walletModel.value.avatar,
                  cashRecord: walletCtr.walletModel.value.cashRecord,
                );

                (
                  'WalletUpdated',
                  'Updated wallet: cash=${cashValue.toStringAsFixed(2)}, reward=${rewardValue.toStringAsFixed(2)}',
                  orderId: orderId
                );
              }

              // 关闭支付弹窗
              Get.back();
              showSuccess("Payment successfully".tr);
            } else if (result['state'] == 0) {
              // 支付中，继续轮询
              (
                'PaymentProcessing',
                'Payment in progress. State: 0',
                orderId: orderId
              );
            } else if (result['state'] == 2) {
              // 支付失败，停止轮询
              ('PaymentFailed', 'Payment failed! State: 2', orderId: orderId);
              _isPaymentProcessed = true;
              timer.cancel();
              SmartDialog.dismiss();
              // 不关闭支付弹窗，停留在充值页面
              showInfo("Payment failed".tr);
            } else {
              // 其他状态，支付失败或异常
              (
                'PaymentUnknownState',
                'Payment failed with unknown state: ${result['state']}',
                orderId: orderId
              );
              _isPaymentProcessed = true;
              timer.cancel();
              SmartDialog.dismiss();
              // 不关闭支付弹窗，停留在充值页面
              showInfo(
                  "Payment failed. Please try again or check your order status."
                      .tr);
            }
          }
        } catch (e, stackTrace) {

        }
      });
    }
  }

  void topUp() async {
    dismissLoading(status: SmartStatus.loading);

    if (payMethod.value == null || payMethod.value == 0) {
      showToast("Please select a payment method".tr);
      return;
    }

    thirdPay();
  }

  thirdPay() async {
    showLoading();
    Map<String, dynamic> map = {
      "amount": widget.money,
      "couponId": currentSelectIndex.value == -1
          ? 0
          : couponList[currentSelectIndex.value].id,
      "type": widget.type,
      "way": payMethod.value, // 1:bankcard,2:balance,4: alipay-wechat,6:cash
    };
    final pgwModel = await WalletApi.getPGWPaymentTokenAndUrl(map: map);

    (
      'PaymentInit',
      'PGW Payment initialized',
      orderId: pgwModel?.invoiceNo ?? ''
    );
    (
      'PaymentParams',
      'URL: ${pgwModel?.webPaymentUrl}, Token: ${pgwModel?.paymentToken}, InvoiceNo: ${pgwModel?.invoiceNo}',
      orderId: pgwModel?.invoiceNo ?? ''
    );

    if (pgwModel?.webPaymentUrl != null && pgwModel!.webPaymentUrl.isNotEmpty) {
      // 使用内置WebView进行支付，设置跳转目标为钱包页面
      final result = await Get.to(() => PGWWebViewPage(), arguments: {
        "url": pgwModel.webPaymentUrl,
        "paymentToken": pgwModel.paymentToken,
        "orderId": pgwModel?.invoiceNo ?? "", // 传递invoiceNo作为orderId
        "redirectTarget": "wallet" // 充值成功跳转到钱包页面
      });

      // 根据WebView返回结果处理
      if (result == true) {
        // 支付成功（SDK轮询检测到）
        (
          'PaymentSuccess',
          'Third-party payment successful (SDK detected)',
          orderId: pgwModel?.invoiceNo ?? ''
        );
        dismissLoading();
        Get.back();
        showSuccess("Payment successfully".tr);
      } else if (result is String && result.isNotEmpty) {
        // 从webview返回orderId，需要轮询checkOrderState接口
        String returnedOrderId = result;
        (
          'PollingTrigger',
          'WebView returned orderId: $returnedOrderId, starting checkOrderState polling',
          orderId: returnedOrderId
        );

        dismissLoading();

        // 启动轮询checkOrderState接口
        await _startCheckOrderStatePolling(returnedOrderId);
      } else {
        // 支付失败或取消
        (
          'PaymentCancelled',
          'Third-party payment failed or cancelled',
          orderId: pgwModel?.invoiceNo ?? ''
        );
        dismissLoading();
        // 不显示失败提示，让用户自行决定后续操作
      }
    } else {
      (
        'PaymentError',
        'Invalid payment URL',
        orderId: pgwModel?.invoiceNo ?? ''
      );
      dismissLoading();
      showInfo("Payment failed7".tr);
      Get.back();
    }
  }
}
