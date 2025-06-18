/**
    author:mac
    创建日期:2023/2/21
    描述:
 */
import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AssetsUtils.empty,
            width: 105.w,
            height: 94.w,
          ),
          Text(
            "No Data".tr,
            style: TextStyle(
              color: toColor('1a1a1a'),
              fontSize: 14.sp,
              fontFamily: FONT_MEDIUM,
            ),
          ).marginOnly(top: 15.h),
        ],
      ),
    );
  }
}
