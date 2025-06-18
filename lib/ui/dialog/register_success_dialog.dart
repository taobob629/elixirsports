import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../config/icon_font.dart';
import '../widget/my_button_widget.dart';

class RegisterSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 315.w,
        height: 350.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 40.w,
              right: 40.w,
              top: 20.h,
              child: SvgPicture.asset(
                AssetsUtils.icon_caidai,
              ),
            ),
            Positioned(
              right: 20.w,
              top: 18.h,
              child: InkWell(
                onTap: () => dismissLoading(),
                child: Icon(
                  Icons.close,
                  color: toColor('1a1a1a'),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              top: 100.h,
              child: Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
                size: 53.w,
              ),
            ),
            Positioned(
              right: 25.w,
              left: 25.w,
              bottom: 20.h,
              child: Column(
                children: [
                  Text(
                    'Register Success'.tr,
                    style: TextStyle(
                      color: toColor('#3D3D3D'),
                      fontSize: 17.sp,
                      fontFamily: FONT_LIGHT,
                    ),
                  ),
                  Text(
                    'You have successfully registered. Please go to the store front desk to activate.'
                        .tr,
                    style: TextStyle(
                      color: toColor('#767676'),
                      fontSize: 13.sp,
                      fontFamily: FONT_LIGHT,
                    ),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: 12.h),
                  MyButtonWidget(
                    btnText: "I GOT IT".tr,
                    marginLeft: 15.w,
                    marginRight: 15.w,
                    marginTop: 40.h,
                    marginBottom: 0,
                    onTap: () => dismissLoading(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
