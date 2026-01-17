import 'dart:io';

import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/storage_manager.dart';
import '../../../../utils/toast_utils.dart';
import '../../../base/base_scaffold.dart';
import '../../../config/icon_font.dart';
import '../../dialog/confirm_dialog.dart';

class DeveloperPage extends StatelessWidget {
  final controller = Get.put(DeveloperPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Developer".tr,
      body: Obx(() => Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                Text(
                  "Push Token".tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: controller.pushToken.value));
                    showToast(
                        "The push token has been copied to your clipboard".tr);
                  },
                  child: Text(
                    controller.pushToken.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                20.verticalSpace,
                Text(
                  "Environment".tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.verticalSpace,
                Row(
                  children: [
                    Radio<String>(
                        activeColor: toColor('e33e45'),
                        fillColor: MaterialStateProperty.all(Colors.black),
                        value: "dev175",
                        groupValue: controller.env.value,
                        onChanged: (value) {
                          controller.env.value = value!;
                        }),
                    RichText(
                      text: TextSpan(
                        text: "dev175: \n",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "http://146.56.192.175:8091/",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                        activeColor: toColor('e33e45'),
                        fillColor: MaterialStateProperty.all(Colors.black),
                        value: "dev180",
                        groupValue: controller.env.value,
                        onChanged: (value) {
                          controller.env.value = value!;
                        }),
                    RichText(
                      text: TextSpan(
                        text: "dev180: \n",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "http://43.159.57.180:8091/",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                        activeColor: toColor('e33e45'),
                        fillColor: MaterialStateProperty.all(Colors.black),
                        value: "prod",
                        groupValue: controller.env.value,
                        onChanged: (value) {
                          controller.env.value = value!;
                        }),
                    RichText(
                      text: TextSpan(
                        text: "prod: \n",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "http://www.elixiresports.com:8091/",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
      floatingActionButton: InkWell(
        onTap: () {
          controller.saveEnv();
          Get.dialog(
            const ConfirmDialog(
              title: 'Restart required',
              info:
                  'Please restart the app to make the configuration take effect',
            ),
            barrierColor: Colors.black26,
          ).whenComplete(() async {
            exit(0);
          });
        },
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: toColor('#141517'),
            borderRadius: BorderRadius.circular(5.r),
          ),
          margin: EdgeInsets.only(
            top: 15.h,
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
          ),
          alignment: Alignment.center,
          child: Text(
            "SAVE".tr,
            style: TextStyle(
              color: toColor('ffffff'),
              fontFamily: FONT_LIGHT,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class DeveloperPageController extends GetxController {
  var pushToken = "".obs;

  var env = "prod".obs;

  @override
  void onReady() {
    super.onReady();
    pushToken.value = StorageManager.getPushToken();
    env.value = StorageManager.getEnv();
  }

  void saveEnv() {
    StorageManager.setEnv(env.value);
  }
}
