import 'dart:io';

import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../api/profile_api.dart';

class ChangeAvatarDialog extends StatelessWidget {
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
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => openCamera(),
              child: Container(
                width: 1.sw,
                height: 56.h,
                alignment: Alignment.center,
                child: Text(
                  "Take Photo".tr,
                  style: TextStyle(
                    color: toColor('#3D3D3D'),
                    fontFamily: FONT_MEDIUM,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Divider(
              color: toColor("EEEEEE"),
              height: 1.h,
            ),
            InkWell(
              onTap: () => chooseAlbum(),
              child: Container(
                width: 1.sw,
                height: 56.h,
                alignment: Alignment.center,
                child: Text(
                  "Choose from Album".tr,
                  style: TextStyle(
                    color: toColor('#3D3D3D'),
                    fontFamily: FONT_MEDIUM,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: 6.h,
              color: toColor("F5F5F5"),
            ),
            InkWell(
              onTap: () => dismissLoading(),
              child: Container(
                width: 1.sw,
                height: 56.h,
                alignment: Alignment.center,
                child: Text(
                  "Cancel".tr,
                  style: TextStyle(
                    color: toColor('#3D3D3D'),
                    fontFamily: FONT_MEDIUM,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  void openCamera() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(Get.context!);
    if (entity != null) {
      File? file = await entity.file;
      if (file != null) {
        dismissLoading(result: file.path);
      } else {
        dismissLoading();
      }
    } else {
      dismissLoading();
    }
  }

  void chooseAlbum() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(maxAssets: 1),
    );
    if (result != null && result.isNotEmpty) {
      File? file = await result[0].file;
      if (file != null) {
        dismissLoading(result: file.path);
      } else {
        dismissLoading();
      }
    } else {
      dismissLoading();
    }
  }
}
