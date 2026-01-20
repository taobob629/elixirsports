import 'package:elixir_esports/ui/pages/settings/update_name_page.dart';
import 'package:elixir_esports/ui/pages/settings/update_phone_page.dart';
import 'package:elixir_esports/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/user_controller.dart';
import '../../../getx_ctr/settings_ctr.dart';
import '../../widget/my_button_widget.dart';

class SettingsPage extends BasePage<SettingsCtr> {
  String _maskPhoneNumber(String phone) {
    if (phone.isEmpty || phone.length < 4) {
      return '';
    }
    return '*' * (phone.length - 4) + phone.substring(phone.length - 4);
  }

  @override
  SettingsCtr createController() => SettingsCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Setting".tr,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 25.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(15.w, 20.h, 20.w, 25.h),
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => controller.updateAvatar(),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Profile picture".tr,
                              style: TextStyle(
                                color: toColor('#767676'),
                                fontSize: 14.sp,
                                fontFamily: FONT_LIGHT,
                              ),
                            ),
                          ),
                          ImageUtil.networkImage(
                            url:
                                "${UserController.find.profileModel.value.avatar}",
                            width: 40.w,
                            height: 40.w,
                            border: 40.r,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      color: toColor('EEEEEE'),
                    ).marginSymmetric(vertical: 15.h),
                    InkWell(
                      onTap: () => Get.to(() => UpdateNamePage()),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "User nickname".tr,
                              style: TextStyle(
                                color: toColor('#767676'),
                                fontSize: 14.sp,
                                fontFamily: FONT_LIGHT,
                              ),
                            ),
                          ),
                          Text(
                            UserController.find.profileModel.value.name ?? '',
                            style: TextStyle(
                              color: toColor('#1a1a1a'),
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: toColor('#767676'),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      color: toColor('EEEEEE'),
                    ).marginSymmetric(vertical: 15.h),
                    InkWell(
                      onTap: () => controller.handlePasswordTap(),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Password".tr,
                              style: TextStyle(
                                color: toColor('#767676'),
                                fontSize: 14.sp,
                                fontFamily: FONT_LIGHT,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: toColor('#767676'),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      color: toColor('EEEEEE'),
                    ).marginSymmetric(vertical: 15.h),
                    InkWell(
                      onTap: () => Get.to(() => UpdatePhonePage()),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Phone Number".tr,
                              style: TextStyle(
                                color: toColor('#767676'),
                                fontSize: 14.sp,
                                fontFamily: FONT_LIGHT,
                              ),
                            ),
                          ),
                          Text(
                            _maskPhoneNumber(
                                UserController.find.userModel.value.phone ??
                                    ''),
                            style: TextStyle(
                              color: toColor('#1a1a1a'),
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: toColor('#767676'),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      color: toColor('EEEEEE'),
                    ).marginSymmetric(vertical: 15.h),
                    // InkWell(
                    //   onTap: () => Get.to(() => BankCardsPage(), arguments: false),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Text(
                    //           "Bank Cards".tr,
                    //           style: TextStyle(
                    //             color: toColor('#767676'),
                    //             fontSize: 14.sp,
                    //             fontFamily: FONT_LIGHT,
                    //           ),
                    //         ),
                    //       ),
                    //       Icon(
                    //         Icons.keyboard_arrow_right_outlined,
                    //         color: toColor('#767676'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Divider(
                    //   height: 1.h,
                    //   color: toColor('EEEEEE'),
                    // ).marginSymmetric(vertical: 15.h),
                    InkWell(
                      onTap: () => controller.checkVersion(),
                      child: FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          String version = snapshot.data?.version ?? '';
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Version".tr,
                                  style: TextStyle(
                                    color: toColor('#767676'),
                                    fontSize: 14.sp,
                                    fontFamily: FONT_LIGHT,
                                  ),
                                ),
                              ),
                              Text(
                                version,
                                style: TextStyle(
                                  color: toColor('#1a1a1a'),
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: toColor('#767676'),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      color: toColor('EEEEEE'),
                    ).marginSymmetric(vertical: 15.h),
                    InkWell(
                      onTap: () => controller.deleteUser(),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Delete Account".tr,
                              style: TextStyle(
                                color: toColor('#767676'),
                                fontSize: 14.sp,
                                fontFamily: FONT_LIGHT,
                              ),
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              color: toColor('#1a1a1a'),
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: toColor('#767676'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              MyButtonWidget(
                btnText: "LOGOUT".tr,
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 40.h,
                onTap: () => UserController.find.appLogout(),
              ),
            ],
          ),
        ),
      );
}
