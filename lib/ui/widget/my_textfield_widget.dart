import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color_utils.dart';

class MyTextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool password;
  final bool readOnly;
  final TextEditingController? controller;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final double? marginTop;
  final double? marginBottom;
  final double? marginLeft;
  final double? marginRight;
  final TextInputType? keyboardType;
  final Function? onTap;
  final double? height;

  const MyTextFieldWidget({
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.height,
    this.readOnly = false,
    required this.hintText,
    this.password = false,
    this.controller,
    this.marginTop,
    this.marginBottom,
    this.marginLeft,
    this.marginRight,
    this.keyboardType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap?.call(),
        child: Container(
          height: height ?? 44.h,
          decoration: BoxDecoration(
            color: toColor('#ECF1FA'),
            borderRadius: BorderRadius.circular(8.r),
          ),
          margin: EdgeInsets.only(
            top: marginTop ?? 0,
            bottom: marginBottom ?? 0,
            left: marginLeft ?? 0,
            right: marginRight ?? 0,
          ),
          child: Row(
            children: [
              if (leftIcon != null) 10.horizontalSpace,
              if (leftIcon != null) leftIcon!,
              Expanded(
                child: Container(
                  height: 44.h,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15.w),
                  child: IgnorePointer(
                    ignoring: readOnly,
                    child: TextField(
                      controller: controller,
                      keyboardType: keyboardType ?? TextInputType.text,
                      textInputAction: TextInputAction.search,
                      obscureText: password,
                      readOnly: readOnly,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        isCollapsed: true,
                        hintText: hintText,
                        hintStyle: TextStyle(
                          color: toColor('#A2A2A2'),
                          fontSize: 12.sp,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
              if (rightIcon != null) rightIcon!,
              if (rightIcon != null) 10.horizontalSpace,
            ],
          ),
        ),
      );
}
