import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/order_detail_ctr.dart';
import '../../../models/order_detail_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/image_util.dart';

class OrderDetailPage extends BasePage<OrderDetailCtr> {
  @override
  OrderDetailCtr createController() => OrderDetailCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Order Detail".tr,
        body: Obx(() => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...controller.orderDetailModel.value.items
                        .map((e) => itemInfoWidget(e))
                        .toList(),
                    orderingInfoWidget('Total price(S\$)'.tr,
                        controller.orderDetailModel.value.total ?? ''),
                    orderingInfoWidget('Discount(S\$)'.tr,
                        controller.orderDetailModel.value.discount ?? ''),
                    orderingInfoWidget('GST(S\$)'.tr,
                        controller.orderDetailModel.value.tax ?? ''),
                    orderingInfoWidget('SubTotal(S\$)'.tr,
                        controller.orderDetailModel.value.subTotal ?? ''),
                    orderingInfoWidget('Order number'.tr,
                        controller.orderDetailModel.value.orderSn ?? ''),
                    orderingInfoWidget('Order time'.tr,
                        controller.orderDetailModel.value.time ?? ''),
                  ],
                ),
              ),
            )),
        bottomNavigationBar: Obx(() =>
            controller.orderDetailModel.value.status == 0 &&
                    controller.orderDetailModel.value.status == 4
                ? InkWell(
                    onTap: () => Get.off(() => OrderDetailPage()),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: toColor('#141517'),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      margin: EdgeInsets.only(
                        top: 10.h,
                        bottom: 30.h,
                        left: 15.w,
                        right: 15.w,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "GO TO PAY".tr,
                        style: TextStyle(
                          color: toColor('ffffff'),
                          fontFamily: FONT_LIGHT,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 1,
                    height: 1,
                    color: Colors.transparent,
                  )),
      );

  Widget itemInfoWidget(OrderDetailItem item) => Row(
        children: [
          ImageUtil.networkImage(
            url: "${item.image}",
            border: 4.r,
            width: 78.w,
            height: 78.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  style: TextStyle(
                    color: toColor('#1A1A1A'),
                    fontSize: 18.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ).paddingOnly(left: 10.w),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.price == null ? "S\$0" : "S\$${item.price}",
                        style: TextStyle(
                          color: toColor('#EA0000'),
                          fontSize: 17.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ).paddingOnly(left: 10.w, top: 15.h),
                    ),
                    Text(
                      "X${item.num}",
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
      );

  Widget orderingInfoWidget(String name, String value) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: toColor('#767676'),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                flex: 1,
                child: Text(
                  value,
                  style: TextStyle(
                    color: toColor('#1A1A1A'),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 22.h),
          Divider(
            height: 1.h,
            color: toColor('#F0F0F0'),
          )
        ],
      );
}
