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

  // 展开/折叠状态管理
  Map<int, bool> _expandedStatus = {};

  // 检查优惠券类型是否已展开
  bool isExpanded(int couponType) {
    return _expandedStatus[couponType] ?? false;
  }

  // 切换优惠券类型的展开/折叠状态
  void toggleExpanded(int couponType) {
    _expandedStatus[couponType] = !isExpanded(couponType);
    // 重新加载数据以更新 UI
    onRefresh(init: true);
  }

  // 折叠优惠券列表，根据 couponType 分组，每个类型只保留一条数据
  List<dynamic> collapseCoupons(List<CouponsRow> coupons) {
    // 首先按照 couponType 分组
    Map<int, List<CouponsRow>> groupedCoupons = {};

    for (var coupon in coupons) {
      int? couponType = coupon.couponType;
      if (couponType != null) {
        if (!groupedCoupons.containsKey(couponType)) {
          groupedCoupons[couponType] = [];
        }
        groupedCoupons[couponType]!.add(coupon);
      }
    }

    // 转换为列表并保持原有顺序
    List<dynamic> result = [];
    Set<int> processedTypes = {};

    for (var coupon in coupons) {
      int? couponType = coupon.couponType;
      if (couponType != null && !processedTypes.contains(couponType)) {
        processedTypes.add(couponType);

        if (groupedCoupons.containsKey(couponType)) {
          var typeCoupons = groupedCoupons[couponType];
          if (typeCoupons != null) {
            // 检查是否展开
            if (isExpanded(couponType)) {
              // 展开状态，添加该类型的所有优惠券
              result.addAll(typeCoupons);
            } else {
              // 折叠状态，只添加一条优惠券并显示数量
              result.add({
                'coupon': typeCoupons[0],
                'count': typeCoupons.length,
                'couponType': couponType
              });
            }
          }
        }
      }
    }

    return result;
  }

  // 折叠后的优惠券列表
  var collapsedList = <dynamic>[].obs;

  @override
  Future<List<CouponsRow>> loadData({int pageNum = 1}) async {
    final model = await CouponApi.list(
      status: status,
      pageNum: pageNum,
      pageSize: pageSize,
    );
    if (model.coupons != null) {
      List<CouponsRow> coupons = model.coupons!.rows;
      // 对优惠券进行折叠处理
      collapsedList.value = collapseCoupons(coupons);
      return coupons;
    }
    collapsedList.value = [];
    return [];
  }

  void changeStatus(int index) {
    status = index;
    // 切换 tab 时，重置所有优惠券的展开状态，确保自动折叠
    _expandedStatus.clear();
    onRefresh(init: true);
  }
}
