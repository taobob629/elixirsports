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
import '../widget/dashed_line_widget.dart';
import '../widget/my_button_widget.dart';
import '../widget/pay_method_widget.dart';

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

class _TopUpConfirmDialogState extends State<TopUpConfirmDialog> with SingleTickerProviderStateMixin {
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
                                  text: "${couponList.where((item) => item.available == 1).length}",
                                  style: TextStyle(color: toColor('#EA0000')),
                                ),
                              ],
                            ),
                          )),
                          Obx(() => Icon(
                            showCoupon.value ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right_outlined,
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
                          itemBuilder: (c, i) => itemWidget(couponList[i], i),
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
              DashedLineWidget().marginOnly(top: 80.h, left: 15.w, right: 15.w),
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
                    children: [TextSpan(text: (item.expireTime ?? '').split(" ")[0])],
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
              color: item.available == 0 ? Colors.grey : toColor('#3D3D3D'),
            )
                : Icon(
              Icons.check_circle,
              size: 18.w,
              color: Colors.red,
            )),
            Text(
              "Use This Coupon".tr,
              style: TextStyle(
                color: item.available == 0 ? Colors.grey : toColor('#3D3D3D'),
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
      "couponId": currentSelectIndex.value == -1 ? 0 : couponList[currentSelectIndex.value].id,
      "type": widget.type,
      "way": payMethod.value, // 1:bankcard,2:balance,4: alipay-wechat,6:cash
    };
    final pgwModel = await WalletApi.getPGWPaymentTokenAndUrl(map: map);

    debugPrint('pgwModel?.webPaymentUrl: ${pgwModel?.webPaymentUrl}');
    debugPrint('pgwModel?.paymentToken: ${pgwModel?.paymentToken}');
    debugPrint('pgwModel?.invoiceNo: ${pgwModel?.invoiceNo}');

    if (pgwModel?.webPaymentUrl != null && await canLaunchUrlString(pgwModel!.webPaymentUrl)) {
      await launchUrlString(pgwModel.webPaymentUrl);
      dismissLoading();
      Get.back();
    } else {
      dismissLoading();
      showError("Payment failed".tr);
      dismissLoading(status: SmartStatus.allDialog, result: false);
    }
  }
}