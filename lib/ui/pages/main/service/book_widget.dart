import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:elixir_esports/utils/decimal_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../assets_utils.dart';
import '../../../../config/icon_font.dart';
import '../../../../getx_ctr/main_ctr.dart';
import '../../../../getx_ctr/service_ctr.dart';
import '../../../../utils/color_utils.dart';
import 'no_book_widget.dart';

/// 有预定的
class BookWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SizedBox(
            width: 1.sw,
            height: 280.h,
            child: Stack(
              children: [
                SvgPicture.asset(
                  AssetsUtils.mine_top_bg,
                  fit: BoxFit.cover,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          bottom: 4.h,
                          child: Container(
                            color: toColor('#6AFFDF'),
                            width: 30.w,
                            height: 6.h,
                          ),
                        ),
                        Text(
                          "ELIXIR SERVICE".tr,
                          style: TextStyle(
                            color: toColor('#141517'),
                            fontFamily: FONT_MEDIUM,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ).marginOnly(top: 66.h, left: 15.w),
                  ],
                ),
                Positioned(
                  right: 15.w,
                  top: 55.h,
                  child: Image.asset(
                    AssetsUtils.home_logo_icon,
                    width: 106.w,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 115.h,
            left: 15.w,
            right: 15.w,
            bottom: 15.h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Obx(() => Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ServiceCtr.find.bookingDetailModel.value
                                            .storeName ??
                                        '',
                                    style: TextStyle(
                                      color: toColor('#3D3D3D'),
                                      fontFamily: FONT_LIGHT,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                Text(
                                  MainCtr.find.getDistance(ServiceCtr
                                      .find.bookingDetailModel.value.map),
                                  style: TextStyle(
                                    color: toColor('#767676'),
                                    fontFamily: FONT_LIGHT,
                                    fontSize: 12.sp,
                                  ),
                                  textAlign: TextAlign.right,
                                ).paddingOnly(right: 15.w),
                              ],
                            ).paddingOnly(left: 15.w, top: 15.h),
                            InkWell(
                              onTap: () => UserController.find.jumpPhoneOrMap(
                                  map: ServiceCtr
                                      .find.bookingDetailModel.value.map),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AssetsUtils.store_address_icon,
                                    height: 12.h,
                                  ).marginOnly(top: 2.h),
                                  4.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      '${ServiceCtr.find.bookingDetailModel.value.address}\n${ServiceCtr.find.bookingDetailModel.value.postCode}',
                                      style: TextStyle(
                                        color: toColor('#3D3D3D'),
                                        fontFamily: FONT_LIGHT,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ).paddingOnly(left: 15.w, top: 10.h),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  AssetsUtils.store_time_icon,
                                  height: 12.h,
                                ),
                                4.horizontalSpace,
                                Text(
                                  MainCtr.find.showOpenTime(ServiceCtr
                                      .find.bookingDetailModel.value.openTime),
                                  style: TextStyle(
                                    color: toColor('#3D3D3D'),
                                    fontFamily: FONT_LIGHT,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ).paddingOnly(left: 15.w, top: 10.h),
                            Divider(
                              height: 1.h,
                              color: toColor("EEEEEE"),
                            ).marginOnly(
                                top: 12.h,
                                bottom: 20.h,
                                left: 15.w,
                                right: 15.w),
                            Text(
                              "UNLOCK CODE".tr,
                              style: TextStyle(
                                color: toColor('#3d3d3d'),
                                fontFamily: FONT_MEDIUM,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: 120.w,
                              height: 38.h,
                              color: toColor('#F4FAFA'),
                              margin: EdgeInsets.only(top: 10.h),
                              alignment: Alignment.center,
                              child: Text(
                                "${ServiceCtr.find.bookingDetailModel.value.code}",
                                style: TextStyle(
                                  color: toColor('#22B544'),
                                  fontFamily: FONT_LIGHT,
                                  fontSize: 17.sp,
                                  letterSpacing: 6.w,
                                ),
                              ),
                            ),
                            Text(
                              "After arriving at the store, scan the code or enter the unlock code to unlock it"
                                  .tr,
                              style: TextStyle(
                                color: toColor('#767676'),
                                fontSize: 12.sp,
                                fontFamily: FONT_LIGHT,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ).paddingSymmetric(
                                horizontal: 50.w, vertical: 10.h),
                            InkWell(
                              onTap: () => ServiceCtr.find.showOrderInfo.value =
                                  !ServiceCtr.find.showOrderInfo.value,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "ORDERING INFORMATION".tr,
                                      style: TextStyle(
                                        color: toColor('#1A1A1A'),
                                        fontSize: 13.sp,
                                        fontFamily: FONT_MEDIUM,
                                      ),
                                    ),
                                  ),
                                  Obx(() => Icon(
                                        !ServiceCtr.find.showOrderInfo.value
                                            ? Icons.keyboard_arrow_right
                                            : Icons.keyboard_arrow_up,
                                        size: 26.sp,
                                      )),
                                ],
                              ).paddingAll(15.w),
                            ),
                            Obx(() => Visibility(
                                  visible: ServiceCtr.find.showOrderInfo.value,
                                  child: Column(
                                    children: [
                                      orderingInfoWidget("Order No.".tr,
                                          "${ServiceCtr.find.bookingDetailModel.value.orderSn}"),
                                      orderingInfoWidget("Reservation start".tr,
                                          "${ServiceCtr.find.bookingDetailModel.value.bookingTime}"),
                                      // orderingInfoWidget("Reservation ended".tr,
                                      //     "2024-07-04 15:00"),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                          left: 15.w,
                                          top: 15.h,
                                          bottom: 15.h,
                                        ),
                                        child: Text(
                                          "SEAT DETAILS".tr,
                                          style: TextStyle(
                                            color: toColor('#1A1A1A'),
                                            fontSize: 13.sp,
                                            fontFamily: FONT_MEDIUM,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: toColor('#F4FAFA'),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        child: Column(
                                          children: [
                                            ...ServiceCtr.find
                                                .bookingDetailModel.value.sites
                                                .map((e) => Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              AssetsUtils
                                                                  .seat_green_icon,
                                                              width: 30.w,
                                                            ).marginOnly(
                                                                right: 8.w),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    e.area ??
                                                                        '',
                                                                    style:
                                                                        TextStyle(
                                                                      color: toColor(
                                                                          '#3D3D3D'),
                                                                      fontFamily:
                                                                          FONT_LIGHT,
                                                                      fontSize:
                                                                          13.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ).paddingOnly(
                                                                      bottom:
                                                                          2.h),
                                                                  Text(
                                                                    "NO.${e.name}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: toColor(
                                                                          '#3D3D3D'),
                                                                      fontFamily:
                                                                          FONT_LIGHT,
                                                                      fontSize:
                                                                          13.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              "S\$${e.price}/H",
                                                              style: TextStyle(
                                                                color: toColor(
                                                                    '#3D3D3D'),
                                                                fontFamily:
                                                                    FONT_LIGHT,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ).paddingAll(12.r),
                                                        Divider(
                                                          height: 1.h,
                                                          color: toColor(
                                                              "#D4E4E4"),
                                                        ).marginSymmetric(
                                                            horizontal: 12.w),
                                                      ],
                                                    ))
                                                .toList(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "total".tr,
                                                  style: TextStyle(
                                                    color: toColor('#3D3D3D'),
                                                    fontFamily: FONT_LIGHT,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ).paddingOnly(right: 6.w),
                                                Text(
                                                  "S\$${ServiceCtr.find.bookingDetailModel.value.sites.fold<String>("0", (previousValue, element) => previousValue.add(element.price ?? "0"))}/H",
                                                  style: TextStyle(
                                                    color: toColor('#EA0000'),
                                                    fontFamily: FONT_LIGHT,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ).paddingSymmetric(
                                                horizontal: 12.w,
                                                vertical: 20.h),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Visibility(
                              visible: ServiceCtr
                                      .find.bookingDetailModel.value.phone !=
                                  null,
                              child: InkWell(
                                onTap: () => UserController.find.jumpPhoneOrMap(
                                    phone: ServiceCtr
                                        .find.bookingDetailModel.value.phone),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: toColor('#F0F6F9'),
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 15.h),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  height: 50.h,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Contact Store".tr,
                                          style: TextStyle(
                                            color: toColor('#1A1A1A'),
                                            fontSize: 13.sp,
                                            fontFamily: FONT_MEDIUM,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        AssetsUtils.icon_contact,
                                        height: 22.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => ServiceCtr.find.cancelBooking(
                                  ServiceCtr.find.bookingDetailModel.value.id),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    border: Border.all(
                                      color: toColor('#141517'),
                                      width: 1.w,
                                    )),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 25.h),
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                height: 50.h,
                                width: 1.sw,
                                alignment: Alignment.center,
                                child: Text(
                                  "CANCEL".tr,
                                  style: TextStyle(
                                    color: toColor('#141517'),
                                    fontSize: 14.sp,
                                    fontFamily: FONT_MEDIUM,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  weServiceWidget(left: 0, right: 0),
                ],
              ),
            ),
          ),
        ],
      );

  Widget orderingInfoWidget(String name, String value) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: toColor('#767676'),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: toColor('#1A1A1A'),
                  fontSize: 12.sp,
                  fontFamily: FONT_MEDIUM,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ).paddingAll(15.w),
          Divider(
            height: 1.h,
            color: toColor("EEEEEE"),
          ).marginSymmetric(horizontal: 15.w)
        ],
      );
}
