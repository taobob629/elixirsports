import 'package:badges/badges.dart' as badges;
import 'package:elixir_esports/base/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../assets_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/main_ctr.dart';
import '../../../getx_ctr/select_store_ctr.dart';
import '../../../models/store_model.dart';
import '../../../utils/color_utils.dart';
import '../../widget/search_widget.dart';

class SelectStorePage extends BasePage<SelectStoreCtr> {
  @override
  SelectStoreCtr createController() => SelectStoreCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Select Store".tr,
        body: Column(
          children: [
            SearchWidget(
              onSearch: (value) => controller.search(value),
            ).paddingAll(15.r),
            Expanded(
              child: Obx(() => controller.storeList.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (c, i) => itemWidget(controller.storeList[i]),
                      separatorBuilder: (c, i) => 15.verticalSpace,
                      itemCount: controller.storeList.length,
                    )
                  : EmptyView()),
            ),
          ],
        ),
      );

  Widget itemWidget(StoreModel model) => InkWell(
        onTap: () => controller.bookSeat(model),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: badges.Badge(
                        showBadge: model.unreadCount > 0,
                        badgeContent: Text(
                          '${model.unreadCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                        position: badges.BadgePosition.topEnd(),
                        child: Text(
                          model.name ?? '',
                          style: TextStyle(
                            color: toColor('#3D3D3D'),
                            fontFamily: FONT_LIGHT,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    MainCtr.find.getDistance(model.map),
                    style: TextStyle(
                      color: toColor('#767676'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.right,
                  ).paddingOnly(right: 15.w),
                ],
              ).paddingOnly(left: 15.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AssetsUtils.store_address_icon,
                    height: 14.h,
                  ).marginOnly(top: 2.h),
                  Expanded(
                    child: Text(
                      '${model.address}\n${model.postCode}',
                      style: TextStyle(
                        color: toColor('#3D3D3D'),
                        fontFamily: FONT_LIGHT,
                        fontSize: 12.sp,
                      ),
                    ).paddingOnly(left: 4.w),
                  ),
                ],
              ).paddingOnly(left: 15.w, top: 10.h),
              Row(
                children: [
                  Image.asset(
                    AssetsUtils.store_time_icon,
                    height: 14.h,
                  ),
                  4.horizontalSpace,
                  Text(
                    MainCtr.find.showOpenTime(model.openTime),
                    style: TextStyle(
                      color: toColor('#3D3D3D'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ).paddingOnly(left: 15.w, top: 10.h),
            ],
          ),
        ),
      );
}
