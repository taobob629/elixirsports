import 'package:elixir_esports/base/empty_view.dart';
import 'package:elixir_esports/models/order_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../../utils/image_util.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/order_list_ctr.dart';
import 'order_detail_page.dart';

class OrderListPage extends BasePage<OrderListCtr> {
  @override
  OrderListCtr createController() => OrderListCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Order".tr,
        body: Obx(() => controller.list.isNotEmpty
            ? SmartRefresher(
                controller: controller.refreshController,
                onRefresh: () => controller.onRefresh(),
                onLoading: () => controller.loadMore(),
                enablePullUp: true,
                enablePullDown: true,
                child: ListView.separated(
                  itemBuilder: (c, i) => itemWidget(controller.list[i]),
                  separatorBuilder: (c, i) => 10.verticalSpace,
                  itemCount: controller.list.length,
                )).marginAll(15.r)
            : EmptyView()),
      );

  Widget itemWidget(OrderRow model) => InkWell(
        onTap: () => Get.to(() => OrderDetailPage(), arguments: model.id),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.all(15.r),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${model.orderSn}",
                    style: TextStyle(
                      color: toColor('#1A1A1A'),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: toColor('#B4D8DB'),
                      borderRadius: BorderRadius.circular(1.5.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.5.h,
                    ),
                    child: Text(
                      model.orderStatus == 1
                          ? "Completed".tr
                          : model.orderStatus == 3
                              ? "Refund".tr
                              : "Unpaid".tr,
                      style: TextStyle(
                        color: toColor('#396E80'),
                        fontFamily: FONT_LIGHT,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (model.items.isNotEmpty)
                Row(
                  children: [
                    ImageUtil.networkImage(
                      url: "${model.items[0].image}",
                      border: 4.r,
                      width: 78.w,
                      height: 78.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.items[0].name ?? '',
                            style: TextStyle(
                              color: toColor('#1A1A1A'),
                              fontSize: 18.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ).paddingOnly(left: 10.w),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "S\$${model.items[0].price}",
                                  style: TextStyle(
                                    color: toColor('#EA0000'),
                                    fontSize: 17.sp,
                                    fontFamily: FONT_MEDIUM,
                                  ),
                                ).paddingOnly(left: 10.w, top: 15.h),
                              ),
                              Text(
                                "X${model.items[0].num}",
                                style: TextStyle(
                                  color: toColor('#767676'),
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                              ).paddingOnly(left: 10.w, top: 15.h),
                            ],
                          ),
                        ],
                      ).paddingOnly(top: 15.h),
                    ),
                  ],
                ).paddingOnly(top: 12.h),
              Visibility(
                visible: model.items.length > 1,
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: toColor('1A1A1A'),
                  size: 24.sp,
                ),
              ),
              Divider(
                color: toColor('EEEEEE'),
                height: 1.h,
              ).marginOnly(top: 10.h, bottom: 15.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      model.createTime ?? '',
                      style: TextStyle(
                        color: toColor('#767676'),
                        fontSize: 12.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ),
                  Text(
                    "View details".tr,
                    style: TextStyle(
                      color: toColor('#1A1A1A'),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ).paddingOnly(right: 8.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: toColor('#42494F'),
                    size: 16.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
