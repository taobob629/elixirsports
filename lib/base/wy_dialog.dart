import 'dart:io';

import 'package:elixir_esports/assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WyDialog extends StatelessWidget {
  final Widget child;
  final bool forceShow;
  final String logo;
  final double? height;

  WyDialog(
      {required this.child,
      this.forceShow = false,
      this.logo = "default_logo.webp",
      this.height});

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 80) / 2;
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            40.verticalSpace,
            Container(
              width: double.infinity,
              height: height,
              padding: EdgeInsets.only(top: 40.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  bottom: 15.h,
                ),
                child: Center(child: child),
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
