import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectGenderDialog extends StatelessWidget {
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
              onTap: () => dismissLoading(result: "Male"),
              child: Container(
                width: 1.sw,
                height: 56.h,
                alignment: Alignment.center,
                child: Text(
                  "Male".tr,
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
              onTap: () => dismissLoading(result: "Female"),
              child: Container(
                width: 1.sw,
                height: 56.h,
                alignment: Alignment.center,
                child: Text(
                  "Female".tr,
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
}
