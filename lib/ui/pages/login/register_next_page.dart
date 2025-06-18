import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/ui/widget/my_button_widget.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/register_next_ctr.dart';
import '../../widget/my_textfield_widget.dart';

class RegisterNextPage extends BasePage<RegisterNextCtr> {

  @override
  RegisterNextCtr createController() => RegisterNextCtr();

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
                margin: EdgeInsets.only(top: 55.h, left: 15.w),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: toColor("3d3d3d"),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 22.w, top: 42.h),
                child: Text(
                  'Complete Your Profile'.tr,
                  style: TextStyle(
                    color: toColor('#3D3D3D'),
                    fontSize: 19.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  left: 22.w,
                  top: 10.h,
                  bottom: 32.h,
                ),
                child: Text(
                  'So that everyone can get to know you better.'.tr,
                  style: TextStyle(
                    color: toColor('#767676'),
                    fontSize: 13.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ),
              MyTextFieldWidget(
                controller: controller.nameCtr,
                hintText: 'Username'.tr,
                marginLeft: 15.w,
                marginRight: 15.w,
              ),
              MyTextFieldWidget(
                controller: controller.genderCtr,
                hintText: 'Gender'.tr,
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 20.h,
                rightIcon: Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 20.sp,
                ),
                readOnly: true,
                onTap: () => controller.selectGender(),
              ),
              MyTextFieldWidget(
                controller: controller.birthdayCtr,
                hintText: 'Birthday'.tr,
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 20.h,
                rightIcon: SvgPicture.asset(
                  AssetsUtils.icon_calendar,
                  width: 22.w,
                  height: 22.w,
                  fit: BoxFit.fill,
                ),
                readOnly: true,
                onTap: () => controller.selectBirthday(),
              ),
              MyTextFieldWidget(
                controller: controller.emailCtr,
                hintText: 'Email'.tr,
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 20.h,
              ),
              MyTextFieldWidget(
                controller: controller.identyTypeCtr,
                hintText: 'Identity Type'.tr,
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 20.h,
                rightIcon: Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 20.sp,
                ),
                readOnly: true,
                onTap: () => controller.selectIdentity(),
              ),
              MyTextFieldWidget(
                controller: controller.idNumberCtr,
                hintText: 'ID Number'.tr,
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 20.h,
              ),
              MyButtonWidget(
                btnText: "SUBMIT".tr,
                marginLeft: 15.w,
                marginRight: 15.w,
                marginTop: 30.h,
                onTap: () => controller.submit(),
              ),
            ],
          ),
        ),
      );
}
