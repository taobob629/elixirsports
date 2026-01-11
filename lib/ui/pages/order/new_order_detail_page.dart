import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/order_detail_ctr.dart';
import '../../../models/order_detail_model.dart';
import '../../../utils/image_util.dart';



class NewOrderDetailPage extends BasePage<OrderDetailCtr> {
  NewOrderDetailPage({Key? key});
  
  @override
  OrderDetailCtr createController() => OrderDetailCtr();

  @override
  Widget buildBody(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        // AppBar修改：标题居中，调整返回按钮布局
        appBar: AppBar(
          title: Text(
            "Order Detail".tr,
            style: TextStyle(
              fontSize: 17.sp,
              color: const Color(0xff333333),
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true, // 标题居中
          // 导航栏返回
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xff333333)),
            onPressed: () {
              SmartDialog.dismiss(status: SmartStatus.allDialog);
              Get.back();
            },
          ),
        ),
        body: Obx(() => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                children: [
                  // 订单状态显示
                  _orderStatusWidget(),
                  SizedBox(height: 10.h),
                  
                  // 商品列表区域（重构布局）
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: controller.orderDetailModel.value.items
                          .map((e) => _itemInfoWidget(e))
                          .toList(),
                    ),
                  ),
                  
                  // 金额汇总区域
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        _buildAmountRow('Subtotal'.tr,
                            controller.orderDetailModel.value.subTotal ?? '',
                            isAmount: true),
                        _buildAmountRow('GST'.tr,
                            controller.orderDetailModel.value.tax ?? '',
                            isAmount: true),
                        _buildAmountRow('Service Charge'.tr,
                            controller.orderDetailModel.value.service ?? '',
                            isAmount: true),
                        _buildAmountRow('Member Discount'.tr,
                            controller.orderDetailModel.value.memberDiscount ?? '',
                            isAmount: true),
                        _buildAmountRow('Coupon Discount'.tr,
                            controller.orderDetailModel.value.discount ?? '',
                            isAmount: true),
                        _buildAmountRow('Order number'.tr,
                            controller.orderDetailModel.value.orderSn ?? '',
                            isAmount: false),
                        _buildAmountRow('Order time'.tr,
                            controller.orderDetailModel.value.time ?? '',
                            isAmount: false),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        // 移除支付按钮，无论订单状态如何都不需要支付功能
        bottomNavigationBar: const SizedBox.shrink(),
      );



  // 移除订单状态显示Widget，不再显示支付状态
  Widget _orderStatusWidget() {
    return const SizedBox.shrink();
  }

  // 商品信息组件
  Widget _itemInfoWidget(OrderDetailItem item) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: ImageUtil.networkImage(
                url: "${item.image}",
                border: 0,
                width: 80.w,
                height: 80.h,
              ),
            ),
            SizedBox(width: 12.w),
            // 商品内容（占满剩余空间）
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 商品名称
                  Text(
                    item.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xff333333),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // 商品关键词标签
                  _buildGoodsKeywords(item.keywords),
                  SizedBox(height: 8.h),
                  // 价格行：价格左，数量右
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 价格
                      Text(
                        item.price == null ? "S\$0.00" : "S\$${item.price!.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffff4d4f),
                        ),
                      ),
                      // 商品数量（靠右）
                      Text(
                        'x${item.num ?? 0}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  /// 构建金额行组件
  Widget _buildAmountRow(String label, String value, {required bool isAmount}) {
    // 转换金额格式，确保显示两位小数和正确的货币符号
    String formattedValue = value;
    if (isAmount) {
      // 尝试解析金额字符串
      double? amount = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
      if (amount != null) {
        formattedValue = "S\$${amount.toStringAsFixed(2)}";
      }
    }
    
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff666666),
            ),
          ),
          Text(
            formattedValue,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }

  // 构建商品关键词标签Widget
  Widget _buildGoodsKeywords(List<String> keywords) {
    // 空列表直接返回空组件，不占用空间
    if (keywords.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity, // 确保容器宽度填满父组件
      child: Wrap(
        spacing: 6.w, // 水平间距
        runSpacing: 4.h, // 垂直间距（换行后）
        alignment: WrapAlignment.start, // 从左到右对齐
        crossAxisAlignment: WrapCrossAlignment.start, // 垂直对齐方式
        children: keywords.map((keyword) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              keyword,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff666666),
              ),
              maxLines: 1, // 确保关键字不换行
              overflow: TextOverflow.ellipsis, // 超长时显示省略号
            ),
          );
        }).toList(),
      ),
    );
  }
}