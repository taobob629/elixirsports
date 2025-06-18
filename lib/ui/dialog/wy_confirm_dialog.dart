import 'dart:io';

import 'package:elixir_esports/assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WyConfirmDialog extends StatelessWidget {
  final Widget child;
  final bool forceShow;
  final String logo;
  final double? height;

  WyConfirmDialog({
    required this.child,
    this.forceShow = false,
    this.logo = "default_logo.webp",
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (forceShow) {
          exit(0);
        }
        return true;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          clipBehavior: Clip.antiAlias,
          width: double.infinity,
          height: height,
          padding: EdgeInsets.only(top: 24.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetsUtils.confirm_dialog_icon,
                width: 35.w,
              ),
              Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Center(child: child),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
