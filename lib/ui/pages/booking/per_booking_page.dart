import 'package:elixir_esports/getx_ctr/pre_booking_page_ctr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../assets_utils.dart';
import '../../../../base/base_page.dart';
import '../../../../base/base_scaffold.dart';
import '../../../../config/icon_font.dart';
import '../../../../getx_ctr/scan_to_unlock_ctr.dart';
import '../../../../getx_ctr/user_controller.dart';
import '../../../../ui/pages/wallet/top_up_page.dart';
import '../../../../utils/color_utils.dart';
import '../../../../utils/image_util.dart';

class PerBookingPage extends BasePage<PreBookingPageCtr> {
  @override
  PreBookingPageCtr createController() => PreBookingPageCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Booking Seats".tr,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                padding: EdgeInsets.all(15.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          controller.preModel.storeName ?? '',
                          style: TextStyle(
                            color: toColor('#3D3D3D'),
                            fontFamily: FONT_LIGHT,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AssetsUtils.store_address_icon,
                          height: 12.h,
                        ),
                        4.horizontalSpace,
                        Expanded(
                          child: Text(
                            controller.preModel.address ?? '',
                            style: TextStyle(
                              color: toColor('#3D3D3D'),
                              fontFamily: FONT_LIGHT,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ).paddingOnly(top: 12.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: controller.preModel.sites
                          .map((site) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    AssetsUtils.seat_green_icon,
                                    width: 40.w,
                                  ),
                                  Text(
                                    site.name ?? '',
                                    style: TextStyle(
                                      color: toColor('#3D3D3D'),
                                      fontFamily: FONT_LIGHT,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ).paddingOnly(top: 28.h, bottom: 10.h),
                    if (controller.preModel.areaName != null &&
                        controller.preModel.areaName != '')
                      Container(
                        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Text(
                          controller.preModel.areaName ?? '',
                          style: TextStyle(
                            color: toColor('#3D3D3D'),
                            fontFamily: FONT_LIGHT,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                width: 1.sw,
                child: Column(
                  children: [
                    orderingInfoWidget(
                        context, 'Price'.tr, controller.preModel.price ?? '',
                        orgPrice: controller.preModel.orgPrice,
                        showOriginalPrice:
                            controller.preModel.orgPrice != null &&
                                controller.preModel.orgPrice !=
                                    controller.preModel.price),
                    orderingInfoWidget(context, 'Discount'.tr,
                        controller.preModel.discount ?? ''),
                    orderingInfoWidget(context, 'Remaining Balance'.tr,
                        controller.preModel.balance ?? ''),
                    // orderingInfoWidget(context, 'Remaining Reward'.tr,
                    //     controller.preModel.points ?? ''),
                    orderingInfoWidget(context, 'Reservation hold'.tr,
                        controller.preModel.endChargeTime ?? '',
                        isBookingDeadline: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => InkWell(
                    onTap: () {
                      if (!controller.isLoading.value) {
                        controller.bookNext();
                      }
                    },
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: controller.isLoading.value
                            ? toColor('#767676')
                            : toColor('#141517'),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      margin: EdgeInsets.only(
                        top: 10.h,
                        bottom: 10.h,
                        left: 15.w,
                        right: 15.w,
                      ),
                      alignment: Alignment.center,
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              "CONFIRM".tr,
                              style: TextStyle(
                                color: toColor('ffffff'),
                                fontFamily: FONT_LIGHT,
                                fontSize: 14.sp,
                              ),
                            ),
                    ),
                  )),
              // 充值按钮
              InkWell(
                onTap: () {
                  // 跳转到充值页面
                  Get.to(() => TopUpPage());
                },
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  margin: EdgeInsets.only(
                    top: 0.h,
                    bottom: 15.h,
                    left: 15.w,
                    right: 15.w,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "TOP UP".tr,
                    style: TextStyle(
                      color: toColor('ffffff'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget orderingInfoWidget(BuildContext context, String name, String value,
          {bool isBookingDeadline = false,
          String? orgPrice,
          bool showOriginalPrice = false}) =>
      Column(
        children: [
          InkWell(
            onTap:
                isBookingDeadline ? () => controller.bookASeat(context) : null,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: isBookingDeadline
                              ? Colors.red
                              : toColor('#767676'),
                          fontSize: 12.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: isBookingDeadline
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isBookingDeadline)
                        Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.red,
                            size: 14.w,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showOriginalPrice && orgPrice != null)
                          Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: Text(
                              orgPrice,
                              style: TextStyle(
                                color: toColor('#1A1A1A'),
                                fontSize: 10.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                decorationThickness: 2.w,
                              ),
                            ),
                          ),
                        Text(
                          value,
                          style: TextStyle(
                            color: isBookingDeadline
                                ? Colors.red
                                : toColor('#1A1A1A'),
                            fontSize: 12.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: isBookingDeadline
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 15.h),
          ),
          Divider(
            height: 1.h,
            color: toColor("EEEEEE"),
          )
        ],
      );
}
