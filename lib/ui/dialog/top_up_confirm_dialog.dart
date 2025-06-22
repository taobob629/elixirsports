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

class _TopUpConfirmDialogState extends State<TopUpConfirmDialog> {
  var showCoupon = false.obs;

  var currentSelectIndex = (-1).obs;

  var couponList = <CouponsRow>[].obs;

  var discount = 0.obs;

  var cardNo = "".obs;

  // 支付方式：9：银行卡 4：支付宝 5：微信  8：PayNow
  var payMethod = 0.obs;

  // // 轮询支付结果的定时器
  // Timer? _pollingTimer;

  // // 倒计时
  // int countDown = 60;

  void getCouponList() async {
    couponList.value = await WalletApi.topUpCoupons(amount: widget.money);
  }

  @override
  void initState() {
    // TODO: implement initState
    getCouponList();
    super.initState();
  }

  @override
  void dispose() {
    // _pollingTimer?.cancel();
    // _pollingTimer = null;
    super.dispose();
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
                    Obx(() => Text(
                          '+S\$${discount.value.toString()}'.tr,
                          style: TextStyle(
                            color: toColor('#EA0000'),
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
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
              // Obx(() => PayMethodWidget(
              //       name: cardNo.value.isNotEmpty ? '${'Bank Card'.tr} (**** **** **** ${cardNo.value.substring(cardNo.value.length - 4)})' : 'Bank Card'.tr,
              //       icon: Image.asset(
              //         AssetsUtils.bank_card_icon,
              //         width: 20.w,
              //         height: 20.w,
              //       ),
              //       isSelect: payMethod.value == 9,
              //       callback: () => payMethod.value = 9,
              //     )),
              // Container(
              //   height: 1.h,
              //   color: toColor('#EEEEEE'),
              //   margin: EdgeInsets.symmetric(
              //     vertical: 14.h,
              //   ),
              // ),
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
        currentSelectIndex.value = -1;
        discount.value = 0;
      } else {
        currentSelectIndex.value = i;
        discount.value = await WalletApi.calculateCoupons(
          voucherId: item.id,
          amount: widget.money,
        );
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

    await WalletApi.topUp(
      amount: discount.value.toString(),
      couponId: currentSelectIndex.value == -1 ? null : couponList[currentSelectIndex.value].id,
    );

    thirdPay();

    // switch (payMethod.value) {
    //   case 0:
    //     bankCardPay();
    //     break;

    //   case 1:
    //     alipay();
    //     break;

    //   case 2:
    //     alipay();
    //     break;
    // }
  }

  // void bankCardPay() async {
  //   BankCardModel? cardInfo = await Get.to(() => BankCardsPage(), arguments: true);
  //   if (cardInfo != null) {
  //     showLoading();
  //     cardNo.value = cardInfo.cardNo ?? "";
  //     Map<String, dynamic> map = {
  //       "amount": widget.money,
  //       "cardNo": cardInfo.cardNo,
  //       "expiryMonth": cardInfo.expiryMonth,
  //       "expiryYear": cardInfo.expiryYear,
  //       "securityCode": cardInfo.securityCode,
  //       "type": widget.type,
  //       "way": 1, // 1:bankcard,2:balance,4: alipay-wechat,6:cash
  //     };
  //     if (currentSelectIndex.value != -1) {
  //       map["couponId"] = couponList[currentSelectIndex.value].id;
  //     }
  //     if (cardInfo.payName != null) {
  //       map["name"] = cardInfo.payName;
  //     }
  //     if (cardInfo.email != null) {
  //       map["email"] = cardInfo.email;
  //     }

  //     final pgwModel = await WalletApi.getPGWPaymentTokenAndUrl(map: map);

  //     Map<String, dynamic> paymentCode = {'channelCode': 'CC'};
  //     Map<String, dynamic> paymentRequest = {
  //       'cardNo': cardInfo.cardNo,
  //       'expiryMonth': cardInfo.expiryMonth,
  //       'expiryYear': cardInfo.expiryYear,
  //       'securityCode': cardInfo.securityCode,
  //     };

  //     Map<String, dynamic> transactionResultRequest = {
  //       'paymentToken': pgwModel?.paymentToken,
  //       'payment': {
  //         'code': {...paymentCode},
  //         'data': {...paymentRequest}
  //       }
  //     };
  //     PGWSDK().proceedTransaction(transactionResultRequest, (response) async {
  //       if (response['responseCode'] == APIResponseCode.transactionAuthenticateRedirect ||
  //           response['responseCode'] == APIResponseCode.transactionAuthenticateFullRedirect) {
  //         String redirectUrl = response['data']; //Open WebView
  //         dismissLoading(status: SmartStatus.loading);
  //         final result = await Get.to(() => PGWWebViewPage(), arguments: {
  //           "paymentToken": pgwModel?.paymentToken,
  //           "url": redirectUrl,
  //           // "url": pgwModel?.webPaymentUrl,
  //         });
  //         if (result != null) {
  //           if (result) {
  //             await WalletApi.payNotifyServer(map: {
  //               "invoiceNo": pgwModel?.invoiceNo,
  //               "orderStatus": 1, // 1支付成功  4支付失败
  //             });
  //           } else {
  //             await WalletApi.payNotifyServer(map: {
  //               "invoiceNo": pgwModel?.invoiceNo,
  //               "orderStatus": 4, // 1支付成功  4支付失败
  //             });
  //           }
  //           dismissLoading(status: SmartStatus.allDialog, result: true);
  //         } else {
  //           dismissLoading(status: SmartStatus.allDialog, result: false);
  //         }
  //       } else if (response['responseCode'] == APIResponseCode.transactionCompleted) {
  //         dismissLoading();
  //         showError("Payment successful".tr);
  //         await WalletApi.payNotifyServer(map: {
  //           "invoiceNo": pgwModel?.invoiceNo,
  //           "orderStatus": 1, // 1支付成功  4支付失败
  //         });
  //         dismissLoading(status: SmartStatus.allDialog, result: true);
  //       } else {
  //         dismissLoading();
  //         showError(response['responseDescription']);
  //         await WalletApi.payNotifyServer(map: {
  //           "invoiceNo": pgwModel?.invoiceNo,
  //           "orderStatus": 4, // 1支付成功  4支付失败
  //         });
  //         dismissLoading(status: SmartStatus.allDialog, result: false);
  //       }
  //     }, (error) async {
  //       dismissLoading();
  //       showError(error);
  //       await WalletApi.payNotifyServer(map: {
  //         "invoiceNo": pgwModel?.invoiceNo,
  //         "orderStatus": 4, // 1支付成功  4支付失败
  //       });
  //       dismissLoading(status: SmartStatus.allDialog, result: false);
  //     });
  //   }
  // }

  // 轮询支付结果
  // void startGettingPaymentResult(String invoiceNo) {
  //   // 先取消之前的定时器
  //   _pollingTimer?.cancel();
  //   // 重置倒计时
  //   countDown = 60;

  //   // 创建新的定时器，每1秒轮询一次
  //   _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     // 倒计时递减
  //     countDown--;

  //     // 如果倒计时结束，取消轮询
  //     if (countDown <= 0) {
  //       timer.cancel();
  //       _pollingTimer = null;
  //       dismissLoading();
  //       showError("支付超时，请重试".tr);
  //       dismissLoading(status: SmartStatus.allDialog, result: false);
  //       return;
  //     }

  //     try {
  //       final result = await WalletApi.getPGWPaymentResult(orderSN: invoiceNo);
  //       if (result != null) {
  //         // 如果支付成功，停止轮询
  //         if (result.status == 1) {
  //           timer.cancel();
  //           _pollingTimer = null;
  //           if (Get.isRegistered<WalletCtr>()) {
  //             WalletCtr.find.requestData();
  //           }
  //           // 关闭对话框并返回结果
  //           dismissLoading(status: SmartStatus.allDialog, result: result.status == 1);
  //           showSuccess(result.notifyMsg);
  //         }
  //       }
  //     } catch (e) {
  //       print('轮询支付结果出错: $e');
  //     }
  //   });
  // }

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
      // Get.back();
      // 开始轮询支付结果
      // startGettingPaymentResult(pgwModel.invoiceNo);
    } else {
      dismissLoading();
      showError("Payment failed".tr);
      dismissLoading(status: SmartStatus.allDialog, result: false);
    }
  }

  // alipay() async {
  //   showLoading();
  //   Map<String, dynamic> map = {
  //     "amount": widget.money,
  //     "type": widget.type,
  //     "way": 4, // 1:bankcard,2:balance,4: alipay-wechat,6:cash
  //   };
  //   final pgwModel = await WalletApi.getPGWPaymentTokenAndUrl(map: map);

  //   print('pgwModel?.webPaymentUrl: ${pgwModel?.webPaymentUrl}');
  //   print('pgwModel?.paymentToken: ${pgwModel?.paymentToken}');
  //   print('pgwModel?.invoiceNo: ${pgwModel?.invoiceNo}');

  //   if (pgwModel?.webPaymentUrl != null && await canLaunchUrlString(pgwModel!.webPaymentUrl)) {
  //     await launchUrlString(pgwModel.webPaymentUrl);
  //     // 开始轮询支付结果
  //     startPollingPaymentResult(pgwModel.invoiceNo);
  //   } else {
  //     dismissLoading();
  //     showError("Payment failed".tr);
  //     dismissLoading(status: SmartStatus.allDialog, result: false);
  //   }
  // }

  // wechatPay() async {
  //   showLoading();
  //   Map<String, dynamic> map = {
  //     "amount": widget.money,
  //     "type": widget.type,
  //     "way": 4, // 1:bankcard,2:balance,4: alipay-wechat,6:cash
  //   };
  //   final pgwModel = await WalletApi.getPGWPaymentTokenAndUrl(map: map);

  //   if (pgwModel?.webPaymentUrl != null && await canLaunchUrlString(pgwModel!.webPaymentUrl)) {
  //     await launchUrlString(pgwModel.webPaymentUrl);
  //     // 开始轮询支付结果
  //     startPollingPaymentResult(pgwModel.invoiceNo);
  //   } else {
  //     dismissLoading();
  //     showError("Payment failed".tr);
  //     dismissLoading(status: SmartStatus.allDialog, result: false);
  //   }
  // }
}
