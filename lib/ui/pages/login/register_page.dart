import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/ui/pages/login/privacy_check.dart';
import 'package:elixir_esports/ui/widget/my_button_widget.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/register_ctr.dart';
import '../../widget/my_textfield_widget.dart';

class RegisterPage extends BasePage<RegisterCtr> {

  @override
  RegisterCtr createController() => RegisterCtr();

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
          child: SingleChildScrollView(
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
                Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: toColor('#ECF1FA'),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Obx(() => InternationalPhoneNumberInput(
                        hintText: 'Phone Number'.tr,
                        onInputChanged: (PhoneNumber number) =>
                            controller.phoneNumber = number,
                        onInputValidated: (bool value) {},
                        ignoreBlank: true,
                        autoValidateMode: AutovalidateMode.disabled,
                        initialValue: PhoneNumber(isoCode: 'SG'),
                        cursorColor: Colors.black,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                        inputDecoration: const InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                        selectorTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                          setSelectorButtonAsPrefixIcon: true,
                          leadingPadding: 15,
                        ),
                        searchBoxDecoration: InputDecoration(
                          hintText: 'Search by country name or code'.tr,
                        ),
                        countries: controller.countries.value,
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: toColor('#ECF1FA'),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  margin: EdgeInsets.only(
                    top: 20.h,
                    left: 15.w,
                    right: 15.w,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AssetsUtils.icon_verification_code,
                        width: 20.w,
                        height: 20.w,
                      ).marginOnly(left: 10.w, right: 10.w),
                      Expanded(
                        child: Container(
                          height: 44.h,
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: controller.codeCtr,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
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
                        onTap: controller.sendVerifyCode,
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
                  controller: controller.passwordCtr,
                  leftIcon: Image.asset(
                    AssetsUtils.icon_password,
                    width: 20.w,
                    height: 20.w,
                  ),
                  hintText: 'Password'.tr,
                  password: true,
                ).marginOnly(top: 20.h, left: 15.w, right: 15.w),

                MyButtonWidget(
                  btnText: "CREATE AN ACCOUNT".tr,
                  marginLeft: 15.w,
                  marginRight: 15.w,
                  marginTop: 25.h,
                  onTap: controller.register,
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
                  onTap: () => Get.back(),
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
                      "LOG IN".tr,
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
        ),
      );
}
