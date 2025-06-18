import 'package:elixir_esports/ui/widget/my_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/settings_ctr.dart';
import '../../widget/my_button_widget.dart';

class UpdateNamePage extends BasePage<SettingsCtr> {

  @override
  SettingsCtr createController() => SettingsCtr();

  @override
  Widget buildBody(BuildContext context) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: BaseScaffold(
          title: "User nickname".tr,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(15.w, 20.h, 20.w, 25.h),
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Column(
                  children: [
                    MyTextFieldWidget(
                      controller: controller.nameCtr,
                      hintText: "Please input your nickname".tr,
                    ),
                  ],
                ),
              ),
              MyButtonWidget(
                btnText: "SAVE".tr,
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 30.h,
                onTap: () => controller.updateUsername(),
              ),
            ],
          ).paddingOnly(bottom: 15.h),
        ),
      );
}
