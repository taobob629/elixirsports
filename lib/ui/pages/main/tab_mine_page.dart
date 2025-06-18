import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:elixir_esports/ui/pages/coupon/coupon_list_page.dart';
import 'package:elixir_esports/ui/pages/main/scan/my_qr_code_page.dart';
import 'package:elixir_esports/ui/pages/settings/settings_page.dart';
import 'package:elixir_esports/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import '../../../assets_utils.dart';
import '../../../base/base_page.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/mine_ctr.dart';
import '../../../utils/color_utils.dart';
import '../booking/book_list_page.dart';
import '../contact_us/contact_us_page.dart';
import '../member/members_page.dart';
import '../order/order_list_page.dart';

class TabMinePage extends BasePage<MineCtr> {

  @override
  MineCtr createController() => MineCtr();

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 1.sw,
              height: 300.h,
              margin: EdgeInsets.only(bottom: 15.h),
              child: Stack(
                children: [
                  SizedBox(
                    height: 280.h,
                    child: SvgPicture.asset(
                      AssetsUtils.mine_top_bg,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 60.h,
                    left: 15.w,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Get.to(() => MyQrCodePage()),
                          child: SvgPicture.asset(
                            AssetsUtils.mine_scan_icon,
                            width: 28.w,
                          ).paddingOnly(right: 16.w),
                        ),
                        InkWell(
                          onTap: () => Get.to(() => SettingsPage()),
                          child: SvgPicture.asset(
                            AssetsUtils.mine_setting_icon,
                            width: 28.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 15.w,
                    top: 110.h,
                    child: InkWell(
                      onTap: () => controller.goDev(),
                      child: Row(
                        children: [
                          avatarWidget(),
                          Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    UserController
                                            .find.profileModel.value.name ??
                                        "",
                                    style: TextStyle(
                                      color: toColor('#1A1A1A'),
                                      fontSize: 18.sp,
                                      fontFamily: FONT_MEDIUM,
                                    ),
                                  ).paddingOnly(left: 10.w),
                                  Text(
                                    UserController.find.profileModel.value.uk ??
                                        "",
                                    style: TextStyle(
                                      color: toColor('1A1A1A'),
                                      fontSize: 12.sp,
                                      fontFamily: FONT_MEDIUM,
                                    ),
                                  ).paddingOnly(left: 10.w, top: 6.h),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 15.w,
                    right: 15.w,
                    bottom: 0,
                    child: SizedBox(
                      height: 77.h,
                      width: 1.sw,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.toWalletPage(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          AssetsUtils.icon_cash,
                                          height: 16.w,
                                          color: toColor('6997FC'),
                                        ),
                                        Text(
                                          'Elixir Wallet'.tr,
                                          style: TextStyle(
                                            color: toColor('#767676'),
                                            fontSize: 13.sp,
                                            fontFamily: FONT_MEDIUM,
                                          ),
                                        ).paddingOnly(left: 4.w),
                                      ],
                                    ),
                                    Obx(() => Text(
                                          'S\$${UserController.find.profileModel.value.balance ?? '0.00'}'
                                              .tr,
                                          style: TextStyle(
                                            color: toColor('#1A1A1A'),
                                            fontSize: 16.sp,
                                            fontFamily: FONT_MEDIUM,
                                          ),
                                        ).paddingOnly(top: 6.h)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          15.horizontalSpace,
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.toWalletPage(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AssetsUtils.icon_reward,
                                              height: 16.w,
                                              color: toColor('6997FC'),
                                            ),
                                            Text(
                                              'Reward Wallet'.tr,
                                              style: TextStyle(
                                                color: toColor('#767676'),
                                                fontSize: 13.sp,
                                                fontFamily: FONT_MEDIUM,
                                              ),
                                            ).paddingOnly(left: 4.w),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Obx(() => Text(
                                          'S\$${UserController.find.profileModel.value.reward ?? '0.00'}'
                                              .tr,
                                          style: TextStyle(
                                            color: toColor('#1A1A1A'),
                                            fontSize: 16.sp,
                                            fontFamily: FONT_MEDIUM,
                                          ),
                                        ).paddingOnly(top: 6.h)),
                                  ],
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
            ),
            Container(
              height: 94.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  menuWidget(AssetsUtils.wallet_icon, "Wallet".tr,
                      onTap: () => controller.toWalletPage()),
                  menuWidget(AssetsUtils.mine_book_icon, "Booking".tr,
                      onTap: () => Get.to(() => BookListPage())),
                  Obx(() => menuWidget(
                        AssetsUtils.mine_coupon_icon,
                        "Coupon".tr,
                        onTap: () => Get.to(() => CouponListPage()),
                        showBadge:
                            (UserController.find.profileModel.value.coupon ??
                                    0) >
                                0,
                        showBadgeContent:
                            UserController.find.profileModel.value.coupon ?? 0,
                      )),
                  menuWidget(AssetsUtils.mine_order_icon, "Order".tr,
                      onTap: () => Get.to(() => OrderListPage())),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              width: 1.sw,
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Elixir Card".tr,
                    style: TextStyle(
                      color: toColor('#141517'),
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(left: 15.w, top: 15.h, bottom: 12.h),
                  Container(
                    height: 110.h,
                    margin: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 20.h),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (c, i) => Obx(() => InkWell(
                            onTap: () => Get.to(
                              () => MemberPage(),
                              arguments: i,
                            ),
                            child: Stack(
                              children: [
                                Image.asset(
                                  UserController.find.profileModel.value
                                              .memberShip[i].level ==
                                          5
                                      ? AssetsUtils.pic_gold
                                      : UserController.find.profileModel.value
                                                  .memberShip[i].level ==
                                              10
                                          ? AssetsUtils.pic_platinum
                                          : AssetsUtils.pic_diamond,
                                  width: 98.w,
                                  height: 100.h,
                                  fit: BoxFit.fill,
                                ),
                                vipIconWidget(UserController.find.profileModel
                                    .value.memberShip[i].level),
                              ],
                            ),
                          )),
                      separatorBuilder: (c, i) => 15.horizontalSpace,
                      itemCount: UserController
                          .find.profileModel.value.memberShip.length,
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
              width: 1.sw,
              margin: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OTHER SERVICES".tr,
                    style: TextStyle(
                      color: toColor('#141517'),
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(left: 15.w, top: 15.h, bottom: 12.h),
                  Row(
                    children: [
                      15.horizontalSpace,
                      menuWidget(
                        AssetsUtils.mine_contact_us_icon,
                        "Contact us".tr,
                        onTap: () => Get.to(() => ContactUsPage()),
                      ),
                      Obx(() => menuWidget(
                            AssetsUtils.icon_online,
                            "Online".tr,
                            onTap: controller.jumpChat,
                            showBadge:
                                UserController.find.unreadMsgCount.value > 0,
                            showBadgeContent:
                                UserController.find.unreadMsgCount.value,
                          )),
                      const Spacer(),
                      const Spacer(),
                      15.horizontalSpace,
                    ],
                  ).paddingOnly(bottom: 15.h),
                ],
              ),
            ),
          ],
        ),
      );

  Widget avatarWidget() => Obx(() => SizedBox(
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
                  url: "${UserController.find.profileModel.value.avatar}",
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
                    visible: UserController.find.profileModel.value.level ==
                            5 ||
                        UserController.find.profileModel.value.level == 10 ||
                        UserController.find.profileModel.value.level == 15,
                    child: Image.asset(
                      UserController.find.profileModel.value.level == 5
                          ? AssetsUtils.no_5_icon
                          : UserController.find.profileModel.value.level == 10
                              ? AssetsUtils.no_10_icon
                              : UserController.find.profileModel.value.level ==
                                      15
                                  ? AssetsUtils.no_15_icon
                                  : AssetsUtils.no_5_icon,
                      height: 28.w,
                    ),
                  )),
            ),
          ],
        ),
      ));

  Widget vipIconWidget(int? level) => Positioned(
        left: 0,
        right: 0,
        top: 4.h,
        child: Obx(() => UserController.find.profileModel.value.level == level
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.star_rate_rounded,
                    size: 12.sp,
                    color: Colors.green,
                  ),
                  Text(
                    'PURCHASED.'.tr,
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: FONT_MEDIUM,
                      fontSize: 7.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ).marginOnly(left: 4.w),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.star_rate_rounded,
                    size: 12.sp,
                    color: Colors.grey,
                  ),
                  Text(
                    'NOT PURCHASED.'.tr,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: FONT_MEDIUM,
                      fontSize: 7.sp,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ).marginOnly(left: 4.w),
                ],
              )),
      );

  Widget menuWidget(
    String icon,
    String name, {
    Function? onTap,
    bool showBadge = false,
    int showBadgeContent = 1,
  }) =>
      Expanded(
        child: InkWell(
          onTap: () => onTap?.call(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              badges.Badge(
                showBadge: showBadge,
                badgeContent: Text(
                  '$showBadgeContent',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
                position: badges.BadgePosition.custom(start: 15.w, top: -6.h),
                child: SvgPicture.asset(
                  icon,
                  height: 27.h,
                ).paddingOnly(bottom: 10.h),
              ),
              Text(
                name,
                style: TextStyle(
                  color: toColor('#1A1A1A'),
                  fontSize: 13.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              )
            ],
          ),
        ),
      );
}
