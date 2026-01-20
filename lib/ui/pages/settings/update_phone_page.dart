import 'package:elixir_esports/ui/widget/my_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/settings_ctr.dart';
import '../../widget/my_button_widget.dart';
import '../../../../utils/color_utils.dart';

class UpdatePhonePage extends BasePage<SettingsCtr> {
  UpdatePhonePage({Key? key}) : super();

  // 状态管理：1表示验证老手机号，2表示验证新手机号
  final RxInt _currentStep = 1.obs;

  @override
  SettingsCtr createController() => SettingsCtr();

  @override
  Widget buildBody(BuildContext context) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: BaseScaffold(
          title: "Change Phone Number".tr,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Obx(() => SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.fromLTRB(15.w, 20.h, 20.w, 25.h),
                        margin: EdgeInsets.only(bottom: 20.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_currentStep.value == 1) ...[
                              // 第一步：验证老手机号
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Current Phone Number'.tr,
                                    style: TextStyle(
                                      color: toColor('#767676'),
                                      fontSize: 12.sp,
                                      fontFamily: FONT_LIGHT,
                                    ),
                                  ).marginOnly(bottom: 8.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: toColor('#ECF1FA'),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 12.h),
                                    child: Text(
                                      _formatPhoneNumber(
                                          controller.oldPhoneNumber ??
                                              PhoneNumber(isoCode: 'SG')),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontFamily: FONT_MEDIUM,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextFieldWidget(
                                      controller: controller.oldCodeCtr,
                                      hintText: "Enter verification code".tr,
                                      keyboardType: TextInputType.number,
                                      onTap: () =>
                                          controller.sendOldPhoneCode(),
                                      rightIcon: Obx(() => Text(
                                            controller.oldCodeCountdown.value >
                                                    0
                                                ? "${controller.oldCodeCountdown.value}s"
                                                : "Get Code".tr,
                                            style: TextStyle(
                                              color: toColor('#767676'),
                                              fontSize: 12.sp,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              // 第二步：验证新手机号
                              Container(
                                decoration: BoxDecoration(
                                  color: toColor('#ECF1FA'),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 0.w),
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: InternationalPhoneNumberInput(
                                  hintText: 'Phone Number'.tr,
                                  onInputChanged: (PhoneNumber number) =>
                                      controller.newPhoneNumber = number,
                                  onInputValidated: (bool value) {},
                                  ignoreBlank: true,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  initialValue: PhoneNumber(isoCode: 'SG'),
                                  cursorColor: Colors.black,
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                  inputDecoration: InputDecoration(
                                    isDense: true,
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                  ),
                                  selectorTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                  selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType.DIALOG,
                                    setSelectorButtonAsPrefixIcon: true,
                                    leadingPadding: 15,
                                  ),
                                  searchBoxDecoration: InputDecoration(
                                    hintText:
                                        'Search by country name or code'.tr,
                                  ),
                                  countries: controller.countries,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextFieldWidget(
                                      controller: controller.newCodeCtr,
                                      hintText: "Enter verification code".tr,
                                      keyboardType: TextInputType.number,
                                      onTap: () =>
                                          controller.sendNewPhoneCode(),
                                      rightIcon: Obx(() => Text(
                                            controller.newCodeCountdown.value >
                                                    0
                                                ? "${controller.newCodeCountdown.value}s"
                                                : "Get Code".tr,
                                            style: TextStyle(
                                              color: toColor('#767676'),
                                              fontSize: 12.sp,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      MyButtonWidget(
                        btnText:
                            _currentStep.value == 1 ? "Next".tr : "Save".tr,
                        marginLeft: 0.w,
                        marginRight: 0.w,
                        marginTop: 0.h,
                        marginBottom: 30.h,
                        onTap: () {
                          if (_currentStep.value == 1) {
                            // 验证老手机号
                            controller.verifyOldPhone().then((success) {
                              if (success) {
                                _currentStep.value = 2;
                              }
                            });
                          } else {
                            // 验证新手机号并保存
                            controller.updatePhone().then((success) {
                              if (success) {
                                Get.back();
                                Get.snackbar("Success".tr,
                                    "Phone number updated successfully".tr,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white);
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                )),
          ),
        ),
      );

  String _formatPhoneNumber(PhoneNumber phoneNumber) {
    String dialCode = phoneNumber.dialCode ?? '+65';
    String phone = phoneNumber.phoneNumber ?? '';
    return '$dialCode $phone';
  }
}
