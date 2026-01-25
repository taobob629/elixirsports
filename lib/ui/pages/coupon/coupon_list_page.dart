import 'package:elixir_esports/base/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../assets_utils.dart';
import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/coupon_list_ctr.dart';
import '../../../models/coupon_list_model.dart';
import '../../widget/container_tab_indicator.dart';
import '../../widget/dashed_line_widget.dart';

class CouponListPage extends BasePage<CouponListCtr> {
  @override
  CouponListCtr createController() => CouponListCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Coupon".tr,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
              // width: 200.w,
              child: TabBar(
                controller: controller.tabController,
                tabs: controller.tabs,
                // isScrollable: false,
                indicatorSize: TabBarIndicatorSize.label,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: (index) => controller.changeStatus(index),
                dividerColor: Colors.transparent,
                indicator: ContainerTabIndicator(
                  height: 4.h,
                  padding: EdgeInsets.only(top: 14.h),
                  colors: [toColor('#1A1A1A'), toColor('#1A1A1A')],
                ),
              ),
            ),
            Expanded(
              child: Obx(() => controller.collapsedList.isNotEmpty
                  ? _buildSmartRefresher()
                  : EmptyView()),
            ),
          ],
        ),
      );

  Widget _buildSmartRefresher() {
    final RefreshController refreshController =
        RefreshController(initialRefresh: false);
    return SmartRefresher(
        controller: refreshController,
        onRefresh: () async {
          await controller.onRefresh();
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          await controller.loadMore();
          refreshController.loadComplete();
        },
        enablePullUp: true,
        enablePullDown: true,
        child: ListView.separated(
          itemBuilder: (c, i) => itemWidget(controller.collapsedList[i]),
          separatorBuilder: (c, i) => 10.verticalSpace,
          itemCount: controller.collapsedList.length,
        ));
  }

  Widget itemWidget(dynamic itemData) {
    CouponsRow item;
    int count = 1;
    int? couponType;
    bool isCollapsed = false;
    
    // 检查 itemData 类型，判断是折叠的优惠券数据还是原始的优惠券对象
    if (itemData is Map<String, dynamic>) {
      // 折叠状态的数据
      item = itemData['coupon'] as CouponsRow;
      count = itemData['count'] as int;
      couponType = itemData['couponType'] as int;
      isCollapsed = true;
    } else if (itemData is CouponsRow) {
      // 展开状态的原始优惠券数据
      item = itemData;
      couponType = item.couponType;
    } else {
      // 未知类型，返回空容器
      return Container();
    }
    
    return InkWell(
      onTap: () {
        // 无论是折叠还是展开状态，都可以切换展开/折叠
        if (couponType != null) {
          controller.toggleExpanded(couponType);
        }
      },
      child: SizedBox(
        height: 120.h,
        child: Stack(
          children: [
            Positioned(
              left: 15.w,
              right: 15.w,
              child: SvgPicture.asset(
                item.couponType == 3 || item.couponType == 5
                    ? AssetsUtils.coupon_red_bg
                    : item.couponType == 8
                        ? AssetsUtils.coupon_lan_bg
                        : AssetsUtils.coupon_lv_bg,
                height: 120.h,
                fit: BoxFit.fill,
              ),
            ),
            // 优惠券数量标签
            if (isCollapsed && count > 1)
              Positioned(
                top: 5.h,
                right: 25.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    'x$count',
                    style: TextStyle(
                      color: toColor('#1A1A1A'),
                      fontFamily: FONT_MEDIUM,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // 展开/折叠指示器
            if (isCollapsed && count > 1 && couponType != null)
              Positioned(
                top: 15.h,
                right: 30.w,
                child: Icon(
                  controller.isExpanded(couponType)
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 16.w,
                ),
              ),
            Positioned(
              left: 30.w,
              top: 15.h,
              child: Text(
                "${item.name}",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: FONT_MEDIUM,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.note ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: FONT_MEDIUM,
                      fontSize: 11.sp,
                    ),
                    maxLines: 2,
                  ),
                ),
                Text(
                  '${item.value}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FONT_MEDIUM,
                    fontSize: 20.sp,
                  ),
                ),
                Text(
                  '${item.unit}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FONT_MEDIUM,
                    fontSize: 11.sp,
                  ),
                ).paddingOnly(left: 6.w, top: 6.h),
              ],
            ).marginOnly(top: 37.h, left: 30.w, right: 30.w),
            DashedLineWidget().marginOnly(top: 80.h, left: 30.w, right: 30.w),
            Positioned(
              bottom: 12.h,
              left: 30.w,
              child: RichText(
                text: TextSpan(
                  text: 'Validity period:'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                  children: [TextSpan(text: item.expireTime ?? '')],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
