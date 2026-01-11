import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:elixir_esports/utils/decimal_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../assets_utils.dart';
import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/book_detail_ctr.dart';
import '../../../getx_ctr/main_ctr.dart';

class BookDetailPage extends BasePage<BookDetailCtr> {
  @override
  BookDetailCtr createController() => BookDetailCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Booking Detail".tr,
        body: Container(
          width: 1.sw,
          margin: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: SingleChildScrollView(
            child: Obx(() => Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          controller.bookingDetailModel.value.storeName ?? '',
                          style: TextStyle(
                            color: toColor('#3D3D3D'),
                            fontFamily: FONT_LIGHT,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 15.w, top: 15.h),
                    InkWell(
                      onTap: () => UserController.find.jumpPhoneOrMap(
                          map: controller.bookingDetailModel.value.map),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            AssetsUtils.store_address_icon,
                            height: 14.h,
                          ).marginOnly(top: 2.h),
                          4.horizontalSpace,
                          Expanded(
                            child: Text(
                              '${controller.bookingDetailModel.value.address}\n${controller.bookingDetailModel.value.postCode}',
                              style: TextStyle(
                                color: toColor('#3D3D3D'),
                                fontFamily: FONT_LIGHT,
                                fontSize: 12.sp,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ).paddingOnly(left: 15.w, top: 10.h),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AssetsUtils.store_time_icon,
                          height: 14.h,
                        ),
                        4.horizontalSpace,
                        Text(
                          MainCtr.find.showOpenTime(
                              controller.bookingDetailModel.value.openTime),
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
                        top: 12.h, bottom: 20.h, left: 15.w, right: 15.w),
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
                        controller.bookingDetailModel.value.code ?? '------',
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
                    ).paddingSymmetric(horizontal: 50.w, vertical: 10.h),
                    Row(
                      children: [
                        Text(
                          "ORDERING INFORMATION".tr,
                          style: TextStyle(
                            color: toColor('#1A1A1A'),
                            fontSize: 13.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                          textAlign: TextAlign.center,
                        ).paddingOnly(left: 15.w, top: 12.h),
                      ],
                    ),
                    orderingInfoWidget("Order No.".tr,
                        controller.bookingDetailModel.value.orderSn ?? ''),
                    orderingInfoWidget("Reservation start".tr,
                        controller.bookingDetailModel.value.bookingTime ?? ''),
                    // orderingInfoWidget(
                    //     "Reservation ended".tr,
                    //     getController()
                    //             .bookingDetailModel
                    //             .value
                    //             .endChargeTime ??
                    //         ''),
                    InkWell(
                      onTap: () => controller.showOrderInfo.value =
                          !controller.showOrderInfo.value,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "SEAT DETAILS".tr,
                              style: TextStyle(
                                color: toColor('#1A1A1A'),
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20.sp,
                          ),
                        ],
                      ).paddingAll(15.w),
                    ),
                    Visibility(
                      visible: controller.showOrderInfo.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: toColor('#F4FAFA'),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          children: [
                            ...controller.bookingDetailModel.value.sites
                                .map((e) => Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              AssetsUtils.seat_green_icon,
                                              width: 30.w,
                                            ).marginOnly(right: 8.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    e.area ?? '',
                                                    style: TextStyle(
                                                      color: toColor('#3D3D3D'),
                                                      fontFamily: FONT_LIGHT,
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ).paddingOnly(bottom: 2.h),
                                                  Text(
                                                    "NO.${e.name}",
                                                    style: TextStyle(
                                                      color: toColor('#3D3D3D'),
                                                      fontFamily: FONT_LIGHT,
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "S\$${e.price}/Hrs",
                                              style: TextStyle(
                                                color: toColor('#3D3D3D'),
                                                fontFamily: FONT_LIGHT,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ).paddingAll(12.r),
                                        Divider(
                                          height: 1.h,
                                          color: toColor("#D4E4E4"),
                                        ).marginSymmetric(horizontal: 12.w),
                                      ],
                                    ))
                                .toList(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                                Expanded(
                                  child: Text(
                                    "S\$${controller.bookingDetailModel.value.sites.fold<String>("0", (previousValue, element) => previousValue.add(element.price ?? "0"))}/Hrs",
                                    style: TextStyle(
                                      color: toColor('#EA0000'),
                                      fontFamily: FONT_LIGHT,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(
                                horizontal: 12.w, vertical: 20.h),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          controller.bookingDetailModel.value.phone != null,
                      child: InkWell(
                        onTap: () => UserController.find.jumpPhoneOrMap(
                            phone: controller.bookingDetailModel.value.phone),
                        child: Container(
                          decoration: BoxDecoration(
                            color: toColor('#F0F6F9'),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 15.h),
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                    Visibility(
                      visible: controller.bookingDetailModel.value.status == 0,
                      child: InkWell(
                        onTap: () => controller.cancelBooking(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: toColor('#141517'),
                              width: 1.w,
                            ),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 25.h,
                          ),
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
                    ),
                  ],
                )),
          ),
        ),
      );

  Widget orderingInfoWidget(String name, String value) => Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  name,
                  style: TextStyle(
                    color: toColor('#767676'),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  value,
                  style: TextStyle(
                    color: toColor('#1A1A1A'),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
