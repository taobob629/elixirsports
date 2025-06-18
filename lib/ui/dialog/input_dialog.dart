import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../base/wy_dialog.dart';
import '../../config/icon_font.dart';
import '../../utils/color_utils.dart';
import '../widget/my_button_widget.dart';

class InputDialog extends StatelessWidget {
  final controller = Get.put(InputDialogController());

  @override
  Widget build(BuildContext context) {
    controller.codeController.text = "";

    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Pin Required".tr,
            style: TextStyle(
              fontSize: 16.sp,
              color: toColor("1A1A1A"),
              fontFamily: FONT_MEDIUM,
            ),
          ),
          Container(
            height: 40.h,
            margin: EdgeInsets.symmetric(vertical: 20.h),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              color: toColor('#ECF1FA'),
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: controller.codeController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                isCollapsed: true,
                hintText: "Input your pin".tr,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: toColor('#A2A2A2'),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
          ),
          MyButtonWidget(
            onTap: () => Get.back(result: controller.codeController.text),
            btnText: "CONFIRM".tr,
          ),
        ],
      ),
    );
  }
}

class InputDialogController extends GetxController {
  late TextEditingController codeController;

  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    codeController.dispose();
  }
}
