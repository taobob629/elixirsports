import 'package:elixir_esports/ui/widget/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/settings_ctr.dart';
import '../../widget/my_textfield_widget.dart';

class PasswordPageNewuser extends BasePage<SettingsCtr> {

  @override
  SettingsCtr createController() => SettingsCtr();

  @override
  Widget buildBody(BuildContext context) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: BaseScaffold(
          title: "PASSWORD".tr,
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(15.w, 20.h, 20.w, 25.h),
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set your password".tr,
                    style: TextStyle(
                      color: toColor('#1a1a1a'),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  Text(
                    "For an improved account security".tr,
                    style: TextStyle(
                      color: toColor('#767676'),
                      fontSize: 13.sp,
                      fontFamily: FONT_LIGHT,
                    ),
                  ).marginOnly(top: 10.h, bottom: 20.h),
                  MyTextFieldWidget(
                    controller: controller.newPsdCtr,
                    hintText: 'Password'.tr,
                    password: true,
                  ).marginSymmetric(vertical: 20.h),
                  MyTextFieldWidget(
                    controller: controller.repeatPsdCtr,
                    hintText: 'Repeat Password'.tr,
                    password: true,
                  ),
                  MyButtonWidget(
                    btnText: "CONFIRM".tr,
                    marginTop: 50.h,
                    marginBottom: 15.h,
                    onTap: () => controller.setPassword(),
                  ),
                ],
              ),
            ),
          ).paddingOnly(bottom: 15.h),
        ),
      );
}
