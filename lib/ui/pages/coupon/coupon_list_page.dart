import 'package:elixir_esports/base/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
              child: TabBar(
                controller: controller.tabController,
                tabs: controller.tabs,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: (index) => controller.changeStatus(index),
                indicator: ContainerTabIndicator(
                  height: 4.h,
                  padding: EdgeInsets.only(top: 14.h),
                  colors: [toColor('#1A1A1A'), toColor('#1A1A1A')],
                ),
              ),
            ),
            Expanded(
              child: Obx(() => controller.list.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (c, i) =>
                          itemWidget(controller.list[i]),
                      separatorBuilder: (c, i) => 10.verticalSpace,
                      itemCount: controller.list.length,
                    )
                  : EmptyView()),
            ),
          ],
        ),
      );

  Widget itemWidget(CouponsRow item) => SizedBox(
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
      );
}
