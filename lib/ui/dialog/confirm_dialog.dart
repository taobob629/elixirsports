import 'package:elixir_esports/ui/dialog/wy_confirm_dialog.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/icon_font.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String info;
  final bool? cancelable;
  final String? confirmBtn;
  final String? concelBtn;
  final Function? onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.info,
    this.cancelable = true,
    this.confirmBtn = "CONFIRM",
    this.concelBtn,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    if (title.contains('Cancel Subscription') || title.contains('取消订阅')) {
      return view2(context);
    } else {
      return view1(context);
    }
  }

  ///可滚动
  Widget view2(BuildContext context) {
    return WyConfirmDialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                    info,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                if (concelBtn != null)
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context, true),
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.w,
                              color: Color(0xFFFFB20E),
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        alignment: Alignment.center,
                        height: 40.h,
                        child: Text(
                          "$concelBtn",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (concelBtn != null)
                  Container(
                    width: 16,
                  ),
                Expanded(
                  child: InkWell(
                    onTap: () => onConfirm == null
                        ? Navigator.pop(context, true)
                        : onConfirm!.call(),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Color(0xFFFFB20E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                      alignment: Alignment.center,
                      height: 40.h,
                      child: Text(
                        "$confirmBtn".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ///不可滚动
  Widget view1(BuildContext context) {
    return WyConfirmDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: toColor('141517'),
              fontFamily: FONT_MEDIUM,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 30.h),
            child: Text(
              info,
              style: TextStyle(
                color: toColor('141517'),
                fontSize: 14.sp,
              ),
            ),
          ),
          Row(
            children: [
              if (concelBtn != null)
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.w,
                            color: const Color(0xFFFFB20E),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      height: 40.h,
                      child: Text(
                        "$concelBtn",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              if (concelBtn != null)
                Container(
                  width: 16,
                ),
              Expanded(
                child: InkWell(
                  onTap: () => onConfirm == null
                      ? Navigator.pop(context, true)
                      : onConfirm!.call(),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFB20E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                    alignment: Alignment.center,
                    height: 40.h,
                    child: Text(
                      "$confirmBtn".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
