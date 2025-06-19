import 'package:elixir_esports/ui/widget/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/forgot_password_ctr.dart';
import '../../widget/my_textfield_widget.dart';

class ForgotPasswordPage extends BasePage<ForgotPasswordCtr> {
  @override
  ForgotPasswordCtr createController() => ForgotPasswordCtr();

  @override
  Widget buildBody(BuildContext context) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: BaseScaffold(
          title: "Forgot Password".tr,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.fromLTRB(15.w, 20.h, 20.w, 25.h),
                  margin:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextFieldWidget(
                        controller: controller.emailCtr,
                        hintText: 'Please enter your account or phone'.tr,
                      ).marginOnly(top: 20.h),
                      Container(
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: toColor('#ECF1FA'),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        margin: EdgeInsets.only(top: 20.h),
                        child: Row(
                          children: [
                            10.horizontalSpace,
                            Expanded(
                              child: Container(
                                height: 40.h,
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  controller: controller.codeCtr,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    isCollapsed: true,
                                    hintText: 'Verification Code'.tr,
                                    hintStyle: TextStyle(
                                      color: toColor('#A2A2A2'),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                ).paddingOnly(left: 4.w),
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.sendVerifyCode(),
                              child: Container(
                                width: 70.w,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: toColor("f5f5f5"),
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Obx(() => Text(
                                      controller.showCountDown.value
                                          ? '${controller.countTime.toString().padLeft(2, '0')}s'
                                          : controller.verifyCodeDesc,
                                      style: TextStyle(
                                        color: toColor('#1A1A1A'),
                                        fontSize: 13.sp,
                                        fontFamily: FONT_MEDIUM,
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MyTextFieldWidget(
                        controller: controller.newPsdCtr,
                        hintText: 'New Password'.tr,
                        password: true,
                      ).marginSymmetric(vertical: 20.h),
                      MyTextFieldWidget(
                        controller: controller.reNewPsdCtr,
                        hintText: 'Repeat New Password'.tr,
                        password: true,
                      ),
                      MyButtonWidget(
                        btnText: "CONFIRM".tr,
                        marginTop: 50.h,
                        marginBottom: 15.h,
                        onTap: controller.submit,
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingOnly(bottom: 15.h),
          ),
        ),
      );
}
