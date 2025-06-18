import 'package:elixir_esports/assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/color_utils.dart';

class SearchWidget extends StatelessWidget {
  final Function(String)? onSearch;

  final TextEditingController searchCtr = TextEditingController();

  SearchWidget({this.onSearch});

  @override
  Widget build(BuildContext context) => Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1.5.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            10.horizontalSpace,
            Expanded(
              child: Container(
                height: 40.h,
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: searchCtr,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    isCollapsed: true,
                    hintText: 'Please enter the store name/address.'.tr,
                    hintStyle: TextStyle(
                      color: toColor('#A2A2A2'),
                      fontSize: 12.sp,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                  onSubmitted: (value) => onSearch?.call(value),
                ).paddingOnly(left: 4.w),
              ),
            ),
            InkWell(
              onTap: () => onSearch?.call(searchCtr.text),
              child: Container(
                width: 50.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AssetsUtils.icon_search,
                  height: 24.w,
                  width: 24.w,
                ),
              ),
            ),
          ],
        ),
      );
}
