import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../assets_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/main_ctr.dart';
import '../../../utils/color_utils.dart';

class ConfirmOrderPage extends BasePage<MainCtr> {

  @override
  MainCtr createController() => MainCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Confirm Order".tr,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          width: 1.sw,
          margin: EdgeInsets.all(15.r),
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            top: 18.h,
            bottom: 34.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "OCTOBER 24TH".tr,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: FONT_MEDIUM,
                  fontSize: 16.sp,
                ),
              ).paddingOnly(bottom: 12.h),
              Row(
                children: [
                  Text(
                    "Store name".tr,
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
                    "Address information".tr,
                    style: TextStyle(
                      color: toColor('#3D3D3D'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ).paddingOnly(top: 10.h),
              Row(
                children: [
                  Image.asset(
                    AssetsUtils.store_time_icon,
                    height: 12.h,
                  ),
                  4.horizontalSpace,
                  Text(
                    "10:00-12:00".tr,
                    style: TextStyle(
                      color: toColor('#3D3D3D'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ).paddingOnly(top: 10.h),
              Divider(
                height: 1.h,
                color: toColor("EEEEEE"),
              ).marginOnly(top: 12.h, bottom: 15.h),
              Text(
                "SEAT DETAILS".tr,
                style: TextStyle(
                  color: toColor('#3D3D3D'),
                  fontFamily: FONT_LIGHT,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(bottom: 21.h),
              Container(
                decoration: BoxDecoration(
                  color: toColor('#F4FAFA'),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    ...[0, 1, 2]
                        .map((e) => Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      color: Colors.greenAccent,
                                      width: 21.w,
                                      height: 19.h,
                                      margin: EdgeInsets.only(right: 8.w),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Battle room".tr,
                                            style: TextStyle(
                                              color: toColor('#3D3D3D'),
                                              fontFamily: FONT_LIGHT,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ).paddingOnly(bottom: 2.h),
                                          Text(
                                            "NO.395".tr,
                                            style: TextStyle(
                                              color: toColor('#3D3D3D'),
                                              fontFamily: FONT_LIGHT,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "S\$17".tr,
                                      style: TextStyle(
                                        color: toColor('#3D3D3D'),
                                        fontFamily: FONT_LIGHT,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                      children: [
                        Expanded(
                          child: Text(
                            "1 seat in total".tr,
                            style: TextStyle(
                              color: toColor('#3D3D3D'),
                              fontFamily: FONT_LIGHT,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                          "S\$17".tr,
                          style: TextStyle(
                            color: toColor('#EA0000'),
                            fontFamily: FONT_LIGHT,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 12.w, vertical: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: InkWell(
          child: Container(
            color: Colors.white,
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: toColor('#141517'),
                borderRadius: BorderRadius.circular(5.r),
              ),
              margin: EdgeInsets.only(
                top: 8.h,
                bottom: 42.h,
                left: 20.w,
                right: 20.w,
              ),
              alignment: Alignment.center,
              child: Text(
                "SUBMIT".tr,
                style: TextStyle(
                  color: toColor('ffffff'),
                  fontFamily: FONT_LIGHT,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
      );
}
