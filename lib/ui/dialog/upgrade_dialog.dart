import 'package:elixir_esports/assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../config/icon_font.dart';
import '../../models/version_model.dart';

class UpgradeDialog extends StatelessWidget {
  final VersionModel model;

  final controller = Get.put(UpgradeDialogController());

  UpgradeDialog({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Image.asset(
              AssetsUtils.upgrade_top_bg,
              fit: BoxFit.cover,
              width: 1.sw,
            ),
            Text(
              'New Version Available'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.bold,
              ),
            ).marginOnly(left: 40.w, top: 70.h),
          ],
        ),
        Transform.translate(
          offset: Offset(0, -14.h),
          child: Container(
            decoration: ShapeDecoration(
              color: const Color(0xFF23201C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
            ),
            child: Column(
              children: [
                24.verticalSpace,
                Center(
                  child: Text(
                    "New Version Available".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                13.verticalSpace,
                Center(
                  child: Text(
                    model.version,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                13.verticalSpace,
                Text(
                  model.intro,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.h, bottom: 0),
                  child: Obx(() {
                    if (controller.showProgress.value == true) {
                      return SizedBox(
                        height: 40,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white24,
                              valueColor:
                              const AlwaysStoppedAnimation<Color>(
                                  Colors.amber),
                              semanticsLabel:
                              controller.progress.value.toString(),
                              value: controller.progress.value / 100,
                              semanticsValue:
                              controller.progress.value.toString(),
                            ),
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () async {
                        StoreRedirect.redirect(
                          androidAppId: "com.elixir.esports",
                          iOSAppId: "6478599943",
                        );
                      },
                      child: Container(
                        width: 250.w,
                        height: 40.h,
                        margin: EdgeInsets.only(bottom: 20.h),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFFB20E),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "UPGRADE".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        )
      ],
    ).marginSymmetric(horizontal: 20.w);
  }
}

class UpgradeDialogController extends GetxController {
  var showProgress = false.obs;
  var progress = 0.obs;

  @override
  void onReady() {
    super.onReady();
    showProgress.value = false;
    progress.value = 0;
  }
}
