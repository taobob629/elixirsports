import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../lang/translations.dart';
import '../../utils/storage_manager.dart';
import '../widget/my_button_widget.dart';

class SwitchLanguageDialog extends StatelessWidget {
  var isEnglish = true.obs;

  SwitchLanguageDialog({super.key}) {
    Locale? locale = Get.locale;
    isEnglish = (locale == ENGLISH).obs;
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 1.sw,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SELECT LANGUAGE'.tr,
                  style: TextStyle(
                    color: toColor('#3D3D3D'),
                    fontSize: 15.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => dismissLoading(),
                  child: Text(
                    'CANCEL'.tr,
                    style: TextStyle(
                      color: toColor('#767676'),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => isEnglish.value = false,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "中文",
                        style: TextStyle(
                          color: isEnglish.value
                              ? toColor('#767676')
                              : toColor('#1A1A1A'),
                          fontFamily: FONT_MEDIUM,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      !isEnglish.value
                          ? Icon(
                              Icons.check_circle,
                              size: 20.sp,
                            )
                          : Icon(
                              Icons.check_circle,
                              size: 20.sp,
                              color: Colors.transparent,
                            )
                    ],
                  ).paddingOnly(top: 30.h)),
            ),
            Divider(
              color: toColor("EEEEEE"),
              height: 1.h,
            ).marginSymmetric(
              vertical: 20.h,
            ),
            InkWell(
              onTap: () => isEnglish.value = true,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "English",
                        style: TextStyle(
                          color: !isEnglish.value
                              ? toColor('#767676')
                              : toColor('#1A1A1A'),
                          fontFamily: FONT_MEDIUM,
                          fontSize: 14.sp,
                        ),
                      ),
                      isEnglish.value
                          ? Icon(
                              Icons.check_circle,
                              size: 20.sp,
                            )
                          : Icon(
                              Icons.check_circle,
                              size: 20.sp,
                              color: Colors.transparent,
                            )
                    ],
                  )),
            ),
            Divider(
              color: toColor("EEEEEE"),
              height: 1.h,
            ).marginSymmetric(
              vertical: 20.h,
            ),
            MyButtonWidget(onTap: () => switchLanguage(), btnText: "SUBMIT".tr),
          ],
        ),
      );

  void switchLanguage() async {
    Locale locale =
        isEnglish.value ? const Locale('en', 'US') : const Locale('zh', 'CN');
    await Get.updateLocale(locale);
    StorageManager.setLocal(locale.languageCode);
    dismissLoading();
  }
}
