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
  late SelectCouponModel _selectedCoupon=new SelectCouponModel(couponId: "0", name: "", expireTime: "", discountAmount: 0.0);
  late double _finalPayAmount;
  late double _discountAmount;

  // 基础金额（保存初始值，避免重复计算时出错）
  late double _basePayAmount;       // 原始待支付金额（无优惠券）
  late double _totalGoodsPrice;     // 商品总价
  late double _totalDiscountPrice;  // 原有优惠折扣

  @override
  void initState() {
    super.initState();
    // 初始化基础金额（保存初始值，用于后续重新计算）
    _totalGoodsPrice = widget.orderData.amountInfo.totalGoodsPrice ?? 0.0;
    _totalDiscountPrice = widget.orderData.amountInfo.totalDiscountPrice ?? 0.0;
    _basePayAmount = widget.orderData.amountInfo.payAmount ?? 0.0;

    // 初始化优惠券和金额
    // _selectedCoupon = widget.orderData.couponList.firstWhere(
    //       (coupon) => coupon.couponValue == widget.orderData.amountInfo.selectedCouponValue,
    //   orElse: () => widget.orderData.couponList[0],
    // );
    _discountAmount = 0.0;
    // 初始金额计算（带边界值校验）
    _finalPayAmount = _calculateFinalAmount(_basePayAmount, _discountAmount);
  }

  /// 核心：金额计算逻辑（抽离为独立方法，便于复用和维护）
  /// [baseAmount] 原始待支付金额 | [couponDiscount] 优惠券折扣金额
  double _calculateFinalAmount(double baseAmount, double couponDiscount) {
    // 1. 边界值校验：折扣金额不能为负
    double validDiscount = couponDiscount < 0 ? 0 : couponDiscount;
    // 2. 计算最终金额：原始金额 - 优惠券折扣（最低为0）
    double finalAmount = baseAmount - validDiscount;
    // 3. 确保最终金额非负
    return finalAmount < 0 ? 0 : finalAmount;
  }

  // 切换优惠券（完善金额计算逻辑）
  void _onCouponChanged(SelectCouponModel newCoupon) {
    setState(() {
      _selectedCoupon = newCoupon;
      _discountAmount = newCoupon.discountAmount;
      // 使用统一的金额计算方法
      _finalPayAmount = _calculateFinalAmount(_basePayAmount, _discountAmount);
    });
  }

  /// 跳转优惠券选择页并处理返回结果（完善价格计算逻辑）
  Future<void> _openCouponSelectPage() async {
    // 跳转优惠券选择页，等待返回结果
    final result = await Get.to(() => const CouponSelectPage());
    if (result != null) {
      // 从优惠券页返回后，解析结果
      String couponId = result['couponId'] ?? '';
      double discountAmount = double.tryParse(result['discountAmount'].toString()) ?? 0.0;

      // 1. 优先查找本地优惠券列表中的匹配项
      SelectCouponModel? newCoupon =null;

      if (newCoupon != null) {
        // 本地有匹配优惠券：更新选中状态并重新计算金额
      } else if (couponId.isNotEmpty) {
        // 本地无匹配优惠券，但有优惠券ID：直接使用返回的折扣金额计算
        setState(() {
          _discountAmount = discountAmount;
          // 重新计算最终金额（带边界校验）
          _finalPayAmount = _calculateFinalAmount(_basePayAmount, _discountAmount);
          // 提示用户（可选）
          showToast("已选择优惠券：抵扣¥${discountAmount.toStringAsFixed(2)}".tr);
        });
      } else {
        // 未选择优惠券/取消选择：重置为无优惠券状态
        setState(() {
          _discountAmount = 0.0;
          _finalPayAmount = _calculateFinalAmount(_basePayAmount, 0.0);
          showToast("已取消选择优惠券".tr);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text(widget.orderData.orderTitle),
        backgroundColor: Colors.white,
        elevation: 1,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // 商品列表区域（完全保留）
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.orderData.orderTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff333333),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: widget.orderData.goodsList.map((goods) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                goods.goodsImage,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: const Color(0xfff5f5f5),
                                    child: const Center(child: Text('图片加载失败')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goods.goodsName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff333333),
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '¥${goods.goodsPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xffff4d4f),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xfffff7e6),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              goods.discountType,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xffff7a45),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'x${goods.count}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff666666),
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
                ],
              ),
            ),

            // 优惠券选择区域（跳转入口）
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 10),
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
                        const Text(
                          '选择优惠券',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff333333),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.orderData.couponLength>0?'共${widget.orderData.couponLength}张可用':"无优惠券可用",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff666666),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffcccccc),
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 显示当前选中的优惠券
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffe0e0e0)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCoupon==null?"":_selectedCoupon.name,
                            style: const TextStyle(fontSize: 15, color: Color(0xff333333)),
                          ),
                          Text(
                            '-¥${_discountAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 15, color: Color(0xffea0000)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 金额汇总区域（显示最新计算的金额）
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  _buildAmountRow('商品总价', '¥${_totalGoodsPrice.toStringAsFixed(2)}'),
                  _buildAmountRow('优惠折扣', '-¥${_totalDiscountPrice.toStringAsFixed(2)}'),
                  _buildAmountRow('优惠券抵扣', '-¥${_discountAmount.toStringAsFixed(2)}'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '实付金额',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333),
                          ),
                        ),
                        Text(
                          '¥${_finalPayAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffff4d4f),
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
      // 底部支付按钮（显示最新计算的实付金额）
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xfff0f0f0))),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff1890ff),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _doPay,
            child: Text(
              '立即支付 ¥${_finalPayAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建金额行组件（完全保留）
  Widget _buildAmountRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff666666),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }
}