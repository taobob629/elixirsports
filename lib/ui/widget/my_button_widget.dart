import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/icon_font.dart';
import '../../utils/color_utils.dart';

class MyButtonWidget extends StatelessWidget {
  final Function? onTap;
  final String btnText;
  final double? height;
  final double? marginTop;
  final double? marginBottom;
  final double? marginLeft;
  final double? marginRight;

  const MyButtonWidget({
    super.key,
    this.onTap,
    required this.btnText,
    this.height,
    this.marginTop,
    this.marginBottom,
    this.marginLeft,
    this.marginRight,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          height: height ?? 40.h,
          decoration: BoxDecoration(
            color: toColor('#141517'),
            borderRadius: BorderRadius.circular(5.r),
          ),
          margin: EdgeInsets.only(
            top: marginTop ?? 15.h,
            bottom: marginBottom ?? 30.h,
            left: marginLeft ?? 0,
            right: marginRight ?? 0,
          ),
          alignment: Alignment.center,
          child: Text(
            btnText,
            style: TextStyle(
              color: toColor('ffffff'),
              fontFamily: FONT_MEDIUM,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
}
