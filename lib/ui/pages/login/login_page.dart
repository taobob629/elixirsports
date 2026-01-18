import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/services/singpass_service.dart';
import 'package:elixir_esports/ui/pages/login/forgot_password_page.dart';
import 'package:elixir_esports/ui/pages/login/privacy_check.dart';
import 'package:elixir_esports/ui/pages/login/register_page.dart';
import 'package:elixir_esports/ui/widget/my_button_widget.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/login_ctr.dart';
import '../../widget/my_textfield_widget.dart';

class LoginPage extends BasePage<LoginCtr> {
  // 使用GetX响应式状态管理登录状态
  final RxBool _isLoading = false.obs;

  @override
  LoginCtr createController() => LoginCtr();

  /// 直接处理 Singpass 登录
  Future<void> _handleSingpassLogin() async {
    if (_isLoading.value) return;

    // 检查隐私条款
    if (!controller.controller.check()) {
      return;
    }

    _isLoading.value = true;

    // 显示全屏加载对话框，去掉黑色转圈loading
    Get.dialog(
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Text(
            'Redirecting to Singpass...'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // 获取 Singpass 认证 URL
      final authUrl = await SingpassService.login();

      // 关闭加载对话框
      Get.back();

      // 使用 url_launcher 打开 Singpass 认证页面
      final uri = Uri.parse(authUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // 关闭加载对话框
      Get.back();

      // 捕获异常，显示错误信息
      Get.snackbar('Error'.tr, 'An error occurred: ${e.toString()}',
          backgroundColor: Colors.red[700]!, colorText: Colors.white);
    } finally {
      _isLoading.value = false;
    }
  }

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
              // OR 分割线和文本
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
              // Singpass 登录按钮
              Obx(() => InkWell(
                    onTap: _handleSingpassLogin,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 25.h,
                        bottom: 30.h,
                        left: 15.w,
                        right: 15.w,
                      ),
                      height: 40.h,
                      width: 1.sw,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isLoading.value ? Colors.red[600] : Colors.red,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: _isLoading.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.w,
                              ),
                            )
                          : Text(
                              "Log in with singpass",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: FONT_MEDIUM,
                                fontSize: 14.sp,
                              ),
                            ),
                    ),
                  )),
              PrivacyCheck(controller: controller.controller)
            ],
          ),
        ),
      );
}
