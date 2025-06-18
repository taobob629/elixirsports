import 'package:elixir_esports/base/getx_refresh_controller.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../api/coupon_api.dart';
import '../config/icon_font.dart';
import '../models/coupon_list_model.dart';

class CouponListCtr extends GetxRefreshController<CouponsRow> {
  static CouponListCtr get find => Get.find();

  late TabController tabController;
  late List<Widget> tabs;

  // 0:AVAILABLE,1:used
  int status = 0;

  @override
  void requestData() {
    tabs = [
      Container(
        height: 34.h,
        alignment: Alignment.center,
        child: Text(
          'AVAILABLE'.tr,
          style: TextStyle(
            color: toColor('#1A1A1A'),
            fontFamily: FONT_MEDIUM,
            fontSize: 14.sp,
          ),
        ),
      ),
      Container(
        height: 34.h,
        alignment: Alignment.center,
        child: Text(
          'USED'.tr,
          style: TextStyle(
            color: toColor('#1A1A1A'),
            fontFamily: FONT_MEDIUM,
            fontSize: 14.sp,
          ),
        ),
      ),
    ];

    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Future<List<CouponsRow>> loadData({int pageNum = 1}) async {
    final model = await CouponApi.list(
      status: status,
      pageNum: pageNum,
      pageSize: pageSize,
    );
    if (model.coupons != null) {
      return model.coupons!.rows;
    }
    return [];
  }

  void changeStatus(int index) {
    status = index;
    onRefresh(init: true);
  }
}
