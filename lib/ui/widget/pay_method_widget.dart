import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayMethodWidget extends StatelessWidget {
  PayMethodWidget({
    super.key,
    this.name = '',
    this.icon,
    this.isSelect = false,
    this.callback,
  });

  String name;
  Widget? icon;
  bool isSelect;
  Function? callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => callback?.call(),
      child: Row(
        children: [
          if (icon != null) icon!,
          10.horizontalSpace,
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: toColor('#3D3D3D'),
                fontSize: 15.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ),
          isSelect
              ? Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 24.sp,
                )
              : Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.grey,
                  size: 24.sp,
                ),
        ],
      ),
    );
  }
}
