import 'package:ai_barcode/ai_barcode.dart';
import 'package:elixir_esports/assets_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/storage_manager.dart';
import '../../../../config/icon_font.dart';
import '../../../../getx_ctr/user_controller.dart';

class MyQrCodePage extends StatelessWidget {
  CreatorController controller = CreatorController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: Stack(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    height: 300.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [
                          Color(0xFF3A3859),
                          Color(0xFF4B385A),
                          Color(0xFF1B1A1E)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SafeArea(
                child: Stack(
                  children: [
                    Container(
                      width: Get.width,
                      margin: EdgeInsets.only(top: 12.h),
                      child: Text(
                        'Scan QR code'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: FONT_LIGHT,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 10.w,
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: Get.width - 30.w,
                height: 460.h,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [Color(0xFFEECAFF), Color(0xFFFFDD97)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 130.h,
              child: SizedBox(
                width: Get.width,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child: ExtendedImage.network(
                        "${UserController.find.profileModel.value.avatar}",
                        width: 66.w,
                        height: 66.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    20.verticalSpace,
                    Text(
                      "${UserController.find.profileModel.value.name}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF1B1A1E),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    Container(
                      width: 220.w,
                      height: 220.w,
                      margin: EdgeInsets.symmetric(vertical: 30.h),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Image.asset(AssetsUtils.qr_code_border),
                          Center(
                            child: Container(
                              width: 180.w,
                              height: 180.w,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: PlatformAiBarcodeCreatorWidget(
                                creatorController: controller,
                                initialValue: StorageManager.getToken(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Scan to link account'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF262731),
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 15.w,
              right: 15.w,
              top: 660.h,
              child: GestureDetector(
                onTap: () => UserController.find.scan(),
                child: Container(
                  height: 46.h,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-1.00, 0.00),
                      end: Alignment(1, 0),
                      colors: [Color(0xFFFF760E), Color(0xFFFFB20E)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 3.h, right: 6.w),
                        child: Image.asset(
                          AssetsUtils.qr_code_icon,
                          scale: 2,
                        ),
                      ),
                      Text(
                        'Scan QR code'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
