import 'package:flutter/material.dart';
import 'dart:math';
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
// 导入订单列表页面
import 'package:elixir_esports/ui/pages/order/order_list_page.dart';

class PayOrderPage extends StatefulWidget {
  final OrderData orderData;

  const PayOrderPage({super.key, required this.orderData});

  @override
  State<PayOrderPage> createState() => _PayOrderPageState();
}

class _PayOrderPageState extends State<PayOrderPage>
    with TickerProviderStateMixin {
  late SelectCouponModel _selectedCoupon = SelectCouponModel(
      couponId: "0", name: "", expireTime: "", couponDiscount: 0.0);
  late double _finalPayAmount;
  late double _discountAmount;
  late double _subTotal; //商品总价;
  late double _tax; //税费，
  late double _service; //服务费
  late double _couponDiscount; //优惠券折扣
  late double _memberDiscountPrice; // 会员折扣

  // 添加金额变化动画相关变量
  late AnimationController _amountController;
  late Animation<double> _amountAnimation;
  double _oldPayAmount = 0.0;
  //
//_finalPayAmount计算公式: _subTotal+（_service）+（_tax）-_couponDiscount-_memberDiscountPrice
  @override
  void initState() {
    super.initState();
    // 初始化基础金额（保存初始值，用于后续重新计算）
    _memberDiscountPrice =
        widget.orderData.amountInfo.memberDiscountPrice ?? 0.0;
    _tax = widget.orderData.amountInfo.tax ?? 0.0;
    _service = widget.orderData.amountInfo.service ?? 0.0;
    _couponDiscount = widget.orderData.amountInfo.couponDiscount ?? 0.0;
    _subTotal = widget.orderData.amountInfo.subTotal ?? 0.0;

    // 初始化优惠券和金额
    _discountAmount = 0.0;
    // 初始金额计算（带边界值校验）
    _finalPayAmount = _calculateFinalAmount();
    _oldPayAmount = _finalPayAmount;

    // 初始化金额变化动画控制器
    _amountController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 初始化金额变化动画
    _amountAnimation = Tween<double>(
      begin: _oldPayAmount,
      end: _finalPayAmount,
    ).animate(_amountController);
  }

  @override
  void dispose() {
    // 释放动画控制器资源
    _amountController.dispose();
    super.dispose();
  }

  /// 核心：金额计算逻辑（抽离为独立方法，便于复用和维护）
  double _calculateFinalAmount() {
    // 使用完整计算公式：_subTotal+（_service）+（_tax）-_couponDiscount-_memberDiscountPrice
    double finalAmount =
        _subTotal + _service + _tax - _couponDiscount - _memberDiscountPrice;
    // 确保最终金额非负
    return finalAmount < 0 ? 0 : finalAmount;
  }

  // 切换优惠券（完善金额计算逻辑）
  void _onCouponChanged(SelectCouponModel newCoupon) {
    setState(() {
      _selectedCoupon = newCoupon;
      _discountAmount = newCoupon.couponDiscount;

      // 保存旧金额用于动画
      _oldPayAmount = _finalPayAmount;
      // 计算新金额
      _finalPayAmount = _calculateFinalAmount();

      // 更新并启动金额变化动画
      _amountController.reset();
      _amountAnimation = Tween<double>(
        begin: _oldPayAmount,
        end: _finalPayAmount,
      ).animate(_amountController);
      // 直接启动金额变化动画
      _amountController.forward();
    });
  }

  /// 跳转优惠券选择页并处理返回结果（完善价格计算逻辑）
  Future<void> _openCouponSelectPage() async {
    // 跳转优惠券选择页，等待返回结果
    final result =
        await Get.to(() => CouponSelectPage(orderId: widget.orderData.orderId));
    if (result != null) {
      // 从优惠券页返回后，解析结果
      String couponId = result['couponId'] ?? '';
      double discountAmount =
          double.tryParse(result['discountAmount'].toString()) ?? 0.0;
      String couponName = result['couponName'] ?? '';
      double memberDiscountPrice =
          double.tryParse(result['memberDiscountPrice'].toString()) ?? 0.0;
      double tax = double.tryParse(result['tax'].toString()) ?? 0.0;
      double service = double.tryParse(result['service'].toString()) ?? 0.0;
      double subTotal = double.tryParse(result['subTotal'].toString()) ?? 0.0;
      double couponDiscount =
          double.tryParse(result['couponDiscount'].toString()) ?? 0.0;

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

          // 保存旧金额用于动画
          _oldPayAmount = _finalPayAmount;
          // 重新计算最终金额
          _finalPayAmount = _calculateFinalAmount();

          // 重置并启动金额变化动画
          _amountController.reset();
          _amountAnimation = Tween<double>(
            begin: _oldPayAmount,
            end: _finalPayAmount,
          ).animate(_amountController);
          _amountController.forward();
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
              name: "No coupon selected".tr,
              expireTime: "",
              couponDiscount: 0.0);

          // 保存旧金额用于动画
          _oldPayAmount = _finalPayAmount;
          // 重新计算最终金额
          _finalPayAmount = _calculateFinalAmount();

          // 重置并启动金额变化动画
          _amountController.reset();
          _amountAnimation = Tween<double>(
            begin: _oldPayAmount,
            end: _finalPayAmount,
          ).animate(_amountController);
          _amountController.forward();
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
        way: widget.orderData.way,
        onPaymentSuccess: () {
          // 支付成功后跳转到订单列表页面
          // 使用Get.to()而不是Get.off()，确保可以正常回退
          Get.to(() => OrderListPage());
        },
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
      width: double.infinity, // 确保容器宽度填满父组件，让Wrap能正确换行
      child: Wrap(
        spacing: 4.w, // 减小水平间距，让标签更紧凑
        runSpacing: 4.h, // 减小垂直间距
        alignment: WrapAlignment.start,
        children: keywords.map((keyword) {
          return Container(
            // 减小内边距，让标签更紧凑
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(3.r),
            ),
            // 移除最大宽度限制，让标签根据内容自适应
            // 只设置最小宽度，确保标签有一定的显示空间
            constraints: BoxConstraints(
              minWidth: 40.w,
            ),
            child: Text(
              keyword,
              style: TextStyle(
                fontSize: 11.sp, // 适当减小字体大小
                color: const Color(0xff666666),
                height: 1.2, // 调整行高
              ),
              // 不允许标签内换行，保持标签为单行
              // 让Wrap组件处理标签级别的换行，确保每个标签完整显示
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
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
                children: widget.orderData.goodsList.asMap().entries.map((entry) {
                  int index = entry.key;
                  GoodsModel goods = entry.value;
                  List<String> goodsKeywords = goods.keyWord ?? [];

                  return Column(
                    children: [
                      if (index > 0)
                        Divider(
                          height: 1.h,
                          color: const Color(0xffe0e0e0),
                        ).paddingSymmetric(vertical: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  _buildGoodsKeywords(goodsKeywords),
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6.w, vertical: 2.h),
                                            decoration: BoxDecoration(
                                              color: const Color(0xfffff7e6),
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
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
                      ),
                    ],
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.orderData.couponLength > 0
                              ? "${widget.orderData.couponLength}${" coupons available".tr}"
                              : "No coupons available".tr,
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
                    SizedBox(height: 12.h),
                    // 显示当前选中的优惠券
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffe0e0e0)),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCoupon.name.isEmpty
                                ? "No coupon selected".tr
                                : _selectedCoupon.name,
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color(0xff333333)),
                          ),
                          Text(
                            '-S\$${_discountAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color(0xffea0000)),
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
                  _buildAmountRow(
                      'Subtotal'.tr, 'S\$${_subTotal.toStringAsFixed(2)}'),
                  _buildAmountRow('GST'.tr, 'S\$${_tax.toStringAsFixed(2)}'),
                  _buildAmountRow(
                      'Service Charge'.tr, 'S\$${_service.toStringAsFixed(2)}'),
                  _buildAmountRow('Member Discount'.tr,
                      '-S\$${_memberDiscountPrice.toStringAsFixed(2)}'),
                  _buildAmountRow('Coupon Discount'.tr,
                      '-S\$${_couponDiscount.toStringAsFixed(2)}'),
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
            child: AnimatedBuilder(
              animation: _amountAnimation,
              builder: (context, child) {
                return Text(
                  "${"Pay Now:".tr} S\$${_amountAnimation.value.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                );
              },
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
