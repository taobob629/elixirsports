import 'package:elixir_esports/ui/pages/store/select_store_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../assets_utils.dart';
import '../../../../config/icon_font.dart';
import '../../../../getx_ctr/user_controller.dart';
import '../../../../utils/color_utils.dart';
import '../../member/members_page.dart';
import '../../wallet/wallet_page.dart';
import '../scan/my_qr_code_page.dart';

/// 没有预定的
class NoBookWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    Expanded(
                      child: Container(
                        width: 1.sw,
                        margin: EdgeInsets.only(
                          left: 15.w,
                          right: 15.w,
                          top: 25.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You Have Not Booked A Service Yet".tr,
                              style: TextStyle(
                                color: toColor('#3D3D3D'),
                                fontFamily: FONT_MEDIUM,
                                fontSize: 15.sp,
                              ),
                            ),
                            InkWell(
                              onTap: () => Get.to(() => SelectStorePage()),
                              child: Container(
                                height: 40.h,
                                width: 250.w,
                                decoration: BoxDecoration(
                                  color: toColor('#141517'),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                margin: EdgeInsets.only(top: 22.h),
                                alignment: Alignment.center,
                                child: Text(
                                  "BOOK NOW".tr,
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
                    ),
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
          weServiceWidget(left: 15.w, right: 15.w),
        ],
      );
}

Widget weServiceWidget({
  required double left,
  required double right,
}) =>
    Container(
      width: 1.sw,
      margin: EdgeInsets.only(left: left, right: right, top: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
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
                "WE SERVICE".tr,
                style: TextStyle(
                  color: toColor('#141517'),
                  fontFamily: FONT_MEDIUM,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).marginOnly(top: 15.h, left: 15.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 1.sh - 420.h),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
              children: [
                InkWell(
                  onTap: () => Get.to(() => MyQrCodePage()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: toColor('#F0F6F9'),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    padding: EdgeInsets.only(
                      top: 10.h,
                      bottom: 14.h,
                      right: 15.w,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "01",
                          style: TextStyle(
                            color: toColor('#141517'),
                            fontFamily: FONT_MEDIUM,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ).marginOnly(left: 15.w, right: 15.w),
                        Expanded(
                          child: Text(
                            "Scan Login".tr,
                            style: TextStyle(
                              color: toColor('#3D3D3D'),
                              fontFamily: FONT_MEDIUM,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          AssetsUtils.icon_scan,
                          height: 32.h,
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                InkWell(
                  onTap: () => Get.to(() => WalletPage()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: toColor('#F0F6F9'),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    padding: EdgeInsets.only(
                      top: 10.h,
                      bottom: 14.h,
                      right: 15.w,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "02",
                          style: TextStyle(
                            color: toColor('#141517'),
                            fontFamily: FONT_MEDIUM,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ).marginOnly(left: 15.w, right: 15.w),
                        Expanded(
                          child: Text(
                            "Top Up Elixir".tr,
                            style: TextStyle(
                              color: toColor('#3D3D3D'),
                              fontFamily: FONT_MEDIUM,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          AssetsUtils.icon_wallet,
                          height: 32.h,
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                InkWell(
                  onTap: () => Get.to(() => MemberPage(), arguments: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: toColor('#F0F6F9'),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    padding: EdgeInsets.only(
                      top: 10.h,
                      bottom: 14.h,
                      right: 15.w,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "03",
                          style: TextStyle(
                            color: toColor('#141517'),
                            fontFamily: FONT_MEDIUM,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ).marginOnly(left: 15.w, right: 15.w),
                        Expanded(
                          child: Text(
                            "Purchase Elixir Card".tr,
                            style: TextStyle(
                              color: toColor('#3D3D3D'),
                              fontFamily: FONT_MEDIUM,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          AssetsUtils.icon_vip,
                          height: 32.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
