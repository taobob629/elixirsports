import 'package:flutter/material.dart';
import 'package:elixir_esports/models/order_model.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'CouponSelectPage.dart';

// 修正路径：确保无多余/
import 'package:elixir_esports/ui/dialog/scan_order_payment_dialog.dart';
// 新增：导入优惠券选择页
import 'package:elixir_esports/ui/pages/scanOrder/CouponSelectPage.dart';

class PayOrderPage extends StatefulWidget {
  final OrderData orderData;

  const PayOrderPage({super.key, required this.orderData});

  @override
  State<PayOrderPage> createState() => _PayOrderPageState();
}

class _PayOrderPageState extends State<PayOrderPage> {
  late SelectCouponModel _selectedCoupon = SelectCouponModel(couponId: "0", name: "", expireTime: "", couponDiscount: 0.0);
  late double _finalPayAmount;
  late double _discountAmount;
  late double _subTotal;//商品总价;
  late double _tax;//税费，
  late double _service;//服务费
  late double _couponDiscount;//优惠券折扣
  late double _memberDiscountPrice;  // 会员折扣
  //
//_finalPayAmount计算公式: _subTotal+（_service）+（_tax）-_couponDiscount-_memberDiscountPrice
  @override
  void initState() {
    super.initState();
    // 初始化基础金额（保存初始值，用于后续重新计算）
    _memberDiscountPrice = widget.orderData.amountInfo.memberDiscountPrice ?? 0.0;
    _tax = widget.orderData.amountInfo.tax ?? 0.0;
    _service = widget.orderData.amountInfo.service ?? 0.0;
    _couponDiscount= widget.orderData.amountInfo.couponDiscount ?? 0.0;
    _subTotal= widget.orderData.amountInfo.subTotal ?? 0.0;

    // 初始化优惠券和金额
    _discountAmount = 0.0;
    // 初始金额计算（带边界值校验）
    _finalPayAmount = _calculateFinalAmount();
  }

  /// 核心：金额计算逻辑（抽离为独立方法，便于复用和维护）
  double _calculateFinalAmount() {
    // 使用完整计算公式：_subTotal+（_service）+（_tax）-_couponDiscount-_memberDiscountPrice
    double finalAmount = _subTotal + _service + _tax - _couponDiscount - _memberDiscountPrice;
    // 确保最终金额非负
    return finalAmount < 0 ? 0 : finalAmount;
  }

  // 切换优惠券（完善金额计算逻辑）
  void _onCouponChanged(SelectCouponModel newCoupon) {
    setState(() {
      _selectedCoupon = newCoupon;
      _discountAmount = newCoupon.couponDiscount;
      // 使用统一的金额计算方法
      _finalPayAmount = _calculateFinalAmount();
    });
  }

  /// 跳转优惠券选择页并处理返回结果（完善价格计算逻辑）
  Future<void> _openCouponSelectPage() async {
    // 跳转优惠券选择页，等待返回结果
    final result = await Get.to(() => CouponSelectPage(orderId: widget.orderData.orderId));
    if (result != null) {
      // 从优惠券页返回后，解析结果
      String couponId = result['couponId'] ?? '';
      double discountAmount = double.tryParse(result['discountAmount'].toString()) ?? 0.0;
      String couponName = result['couponName'] ?? '';
      double memberDiscountPrice = double.tryParse(result['memberDiscountPrice'].toString()) ?? 0.0;
      double tax = double.tryParse(result['tax'].toString()) ?? 0.0;
      double service = double.tryParse(result['service'].toString()) ?? 0.0;
      double subTotal = double.tryParse(result['subTotal'].toString()) ?? 0.0;
      double couponDiscount = double.tryParse(result['couponDiscount'].toString()) ?? 0.0;

      if (couponId.isNotEmpty) {
        // 有优惠券ID：更新所有金额字段
        setState(() {
          _discountAmount = discountAmount;
          _selectedCoupon = SelectCouponModel(
            couponId: couponId,
            name: couponName,
            expireTime: '',
            couponDiscount: couponDiscount,
          );
          // 更新从API返回的金额
          _memberDiscountPrice = memberDiscountPrice;
          _tax = tax;
          _service = service;
          _subTotal = subTotal;
          _couponDiscount = couponDiscount;
          // 重新计算最终金额
          _finalPayAmount = _calculateFinalAmount();
          // 提示用户
          // showToast("已选择优惠券：抵扣¥${discountAmount.toStringAsFixed(2)}".tr);
        });
      } else {
        // 未选择优惠券/取消选择：重置为无优惠券状态
        setState(() {
          _discountAmount = 0.0;
          _couponDiscount = 0.0;
          _selectedCoupon = SelectCouponModel(
            couponId: "0", 
            name: "未选择优惠券", 
            expireTime: "", 
            couponDiscount: 0.0
          );
          // 重新计算最终金额
          _finalPayAmount = _calculateFinalAmount();
          // showToast("已取消选择优惠券".tr);
        });
      }
    }
  }

  /// 打开支付弹窗（保留原有逻辑，金额已通过统一方法计算）
  void showPaymentDialog() {
    // 参数校验（基于最新计算的金额）
    if (widget.orderData.orderId.isEmpty) {
      showToast("订单ID不能为空".tr);
      return;
    }
    if (_finalPayAmount < 0) {
      showToast("支付金额异常，请重新选择优惠券".tr);
      return;
    }

    // 核心配置：使用最新计算的金额参数
    SmartDialog.show(
      builder: (context) => ScanOrderPaymentDialog(
        orderId: widget.orderData.orderId,
        couponId: _selectedCoupon.couponId ?? "0",
        discountAmount: _discountAmount,
        payAmount: _finalPayAmount,
      ),
      alignment: Alignment.bottomCenter,
      clickMaskDismiss: true,
      useSystem: false,
      maskColor: Colors.black.withOpacity(0.5),
      animationTime: const Duration(milliseconds: 300),
    );
  }

  /// 点击立即支付按钮
  void _doPay() {
    showPaymentDialog();
  }

  // 优化：构建商品关键词标签Widget（兼容空列表，list.size==0时不显示）
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      // 1. AppBar修改：标题居中，调整返回按钮布局
      appBar: AppBar(
        title: Text(
          widget.orderData.orderTitle,
          style: TextStyle(
            fontSize: 17.sp,
            color: const Color(0xff333333),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true, // 新增：标题居中
        // 导航栏返回：先关弹窗再返回，避免卡顿
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff333333)),
          onPressed: () {
            SmartDialog.dismiss(status: SmartStatus.allDialog);
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          children: [
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
                children: widget.orderData.goodsList.map((goods) {
                  // 核心修改：直接使用商品模型的keyWord字段（List<String>），移除模拟逻辑
                  List<String> goodsKeywords = goods.keyWord ?? [];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    // 2. 重构商品项布局：图片左，内容右，垂直分布
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 商品图片
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: Image.network(
                            goods.goodsImage,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80.w,
                                height: 80.h,
                                color: const Color(0xfff5f5f5),
                                child: const Center(child: Text('图片加载失败')),
                              );
                            },
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
                                goods.goodsName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: const Color(0xff333333),
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // 商品关键词标签（使用模型的keyWord字段）
                              _buildGoodsKeywords(goodsKeywords),
                              SizedBox(height: 8.h),
                              // 价格行：价格+折扣标签左，数量右
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'S\$${goods.goodsPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffff4d4f),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: const Color(0xfffff7e6),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          goods.discountType,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: const Color(0xffff7a45),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // 商品数量（靠右）
                                  Text(
                                    'x${goods.count}',
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
                }).toList(),
              ),
            ),

            // 优惠券选择区域（样式保留，仅适配尺寸单位）
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: InkWell(
                // 点击跳转优惠券选择页
                onTap: _openCouponSelectPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Please choose coupon'.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: const Color(0xff333333),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.orderData.couponLength > 0 ? "${widget.orderData.couponLength}${"coupons available".tr}" : "No coupons available".tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xff666666),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffcccccc),
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // 显示当前选中的优惠券
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffe0e0e0)),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCoupon.name.isEmpty ? "No coupon selected".tr : _selectedCoupon.name,
                            style: TextStyle(fontSize: 15.sp, color: const Color(0xff333333)),
                          ),
                          Text(
                            '-¥${_discountAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 15.sp, color: const Color(0xffea0000)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 金额汇总区域（仅适配尺寸单位）
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
                  _buildAmountRow('Subtotal'.tr, 'S\$${_subTotal.toStringAsFixed(2)}'),
                  _buildAmountRow('GST'.tr, 'S\$${_tax.toStringAsFixed(2)}'),
                  _buildAmountRow('Service Charge'.tr, 'S\$${_service.toStringAsFixed(2)}'),
                  _buildAmountRow('Member Discount'.tr, '-S\$${_memberDiscountPrice.toStringAsFixed(2)}'),
                  _buildAmountRow('Coupon Discount'.tr, '-S\$${_couponDiscount.toStringAsFixed(2)}'),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total to pay'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff333333),
                          ),
                        ),
                        Text(
                          'S\$${_finalPayAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffff4d4f),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 底部支付按钮（仅适配尺寸单位）
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xfff0f0f0))),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff1890ff),
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: _doPay,
            child: Text(
              "${"Pay Now:".tr} S\$${_finalPayAmount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建金额行组件（仅适配尺寸单位）
  Widget _buildAmountRow(String label, String value) {
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
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }
}