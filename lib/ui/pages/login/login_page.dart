import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/ui/pages/login/forgot_password_page.dart';
import 'package:elixir_esports/ui/pages/login/privacy_check.dart';
import 'package:elixir_esports/ui/pages/login/register_page.dart';
import 'package:elixir_esports/ui/widget/my_button_widget.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/login_ctr.dart';
import '../../widget/my_textfield_widget.dart';

class LoginPage extends BasePage<LoginCtr> {

  @override
  LoginCtr createController() => LoginCtr();

  @override
  Widget buildBody(BuildContext context) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                toColor('#CEEEFF'),
                toColor('#EBFDFF'),
                toColor('#FFFFFF')
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 55.h, left: 15.w, bottom: 10.h),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: toColor("3d3d3d"),
                  ),
                ),
              ),
              Image.asset(
                AssetsUtils.login_logo_icon,
                width: 110.w,
                height: 96.h,
              ).marginOnly(bottom: 50.h),
              MyTextFieldWidget(
                controller: controller.usernameCtr,
                leftIcon: Image.asset(
                  AssetsUtils.icon_phone,
                  width: 20.w,
                  height: 20.w,
                ),
                hintText: 'Please input your account ,email or phone number'.tr,
              ).marginSymmetric(horizontal: 15.w),
              MyTextFieldWidget(
                controller: controller.passwordCtr,
                leftIcon: Image.asset(
                  AssetsUtils.icon_password,
                  width: 20.w,
                  height: 20.w,
                ),
                hintText: 'Password'.tr,
                password: true,
              ).marginOnly(
                top: 20.h,
                left: 15.w,
                right: 15.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Get.to(() => ForgotPasswordPage()),
                    child: Text(
                      "Forgot password".tr,
                      style: TextStyle(
                        color: toColor('#1A1A1A'),
                        fontSize: 13.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ).paddingOnly(top: 15.h, right: 15.w),
                  ),
                ],
              ),
              MyButtonWidget(
                btnText: "LOG IN".tr,
                onTap: () => controller.login(),
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 25.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 85.w,
                    height: 1.h,
                    color: toColor('#D8D8D8'),
                  ),
                  Text(
                    'OR'.tr,
                    style: TextStyle(
                      color: toColor('#1A1A1A'),
                      fontSize: 13.sp,
                    ),
                  ).paddingSymmetric(horizontal: 15.w),
                  Container(
                    width: 85.w,
                    height: 1.h,
                    color: toColor('#D8D8D8'),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.to(() => RegisterPage()),
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
                  height: 40.h,
                  width: 1.sw,
                  alignment: Alignment.center,
                  child: Text(
                    "CREATE AN ACCOUNT".tr,
                    style: TextStyle(
                      color: toColor('#141517'),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ),
              ),
              PrivacyCheck(controller: controller.controller)
            ],
          ),
        ),
      );
}
