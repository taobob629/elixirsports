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
                        Text(
                          controller.preModel.address ?? '',
                          style: TextStyle(
                            color: toColor('#3D3D3D'),
                            fontFamily: FONT_LIGHT,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ).paddingOnly(top: 12.h),
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
                    SizedBox(
                      width: 64.w,
                      height: 74.w,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: 64.w,
                              height: 64.w,
                              child: ImageUtil.networkImage(
                                url:
                                    "${UserController.find.profileModel.value.avatar}",
                                border: 64.r,
                                width: 64.w,
                                height: 64.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Obx(() => Visibility(
                                  visible: UserController
                                              .find.profileModel.value.level ==
                                          5 ||
                                      UserController
                                              .find.profileModel.value.level ==
                                          10 ||
                                      UserController
                                              .find.profileModel.value.level ==
                                          15,
                                  child: Image.asset(
                                    UserController.find.profileModel.value
                                                .level ==
                                            5
                                        ? AssetsUtils.no_5_icon
                                        : UserController.find.profileModel.value
                                                    .level ==
                                                10
                                            ? AssetsUtils.no_10_icon
                                            : UserController.find.profileModel
                                                        .value.level ==
                                                    15
                                                ? AssetsUtils.no_15_icon
                                                : AssetsUtils.no_5_icon,
                                    height: 28.w,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.preModel.userName ?? '',
                          style: TextStyle(
                            color: toColor('#1A1A1A'),
                            fontSize: 18.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ).paddingOnly(left: 10.w),
                      ],
                    ).paddingOnly(top: 15.h),
                    orderingInfoWidget(
                        context, 'Price'.tr, controller.preModel.price ?? ''),
                    orderingInfoWidget(context, 'Discount'.tr,
                        controller.preModel.discount ?? ''),
                    orderingInfoWidget(context, 'Area'.tr,
                        controller.preModel.areaName ?? ''),
                    orderingInfoWidget(context, 'Remaining Balance'.tr,
                        controller.preModel.balance ?? ''),
                    orderingInfoWidget(context, 'Remaining Reward'.tr,
                        controller.preModel.points ?? ''),
                    orderingInfoWidget(context, 'Booking Retention Till'.tr,
                        controller.preModel.endChargeTime ?? '',
                        isBookingDeadline: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Obx(() => InkWell(
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
                    bottom: 15.h,
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
        ),
      );

  Widget orderingInfoWidget(BuildContext context, String name, String value,
          {bool isBookingDeadline = false}) =>
      Column(
        children: [
          InkWell(
            onTap:
                isBookingDeadline ? () => controller.bookASeat(context) : null,
            child: Row(
              children: [
                Expanded(
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
                          padding: EdgeInsets.only(left: 5.w),
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
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isBookingDeadline ? Colors.red : toColor('#1A1A1A'),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight:
                          isBookingDeadline ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
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
