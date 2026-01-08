import 'package:flutter/material.dart';
import 'package:elixir_esports/models/order_model.dart';

class PayOrderPage extends StatefulWidget {
  final OrderData orderData;

  const PayOrderPage({super.key, required this.orderData});

  @override
  State<PayOrderPage> createState() => _PayOrderPageState();
}

class _PayOrderPageState extends State<PayOrderPage> {
  late CouponModel _selectedCoupon; // 选中的优惠券
  late double _finalPayAmount; // 最终实付金额

  @override
  void initState() {
    super.initState();
    // 初始化选中默认优惠券（接口返回的默认选中项）
    _selectedCoupon = widget.orderData.couponList.firstWhere(
          (coupon) => coupon.couponValue == widget.orderData.amountInfo.selectedCouponValue,
      orElse: () => widget.orderData.couponList[0],
    );
    // 初始化实付金额
    _finalPayAmount = widget.orderData.amountInfo.payAmount - _selectedCoupon.couponValue;
  }

  // 切换优惠券
  void _onCouponChanged(CouponModel newCoupon) {
    setState(() {
      _selectedCoupon = newCoupon;
      // 重新计算实付金额
      _finalPayAmount = widget.orderData.amountInfo.payAmount - newCoupon.couponValue;
    });
  }

  // 点击支付按钮
  void _doPay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('支付确认'),
        content: Text(
          '你选择了【${_selectedCoupon.couponName}】，将支付 ¥${_finalPayAmount.toStringAsFixed(2)}\n支付请求已提交，请在新窗口完成支付',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确认'),
          ),
        ],
      ),
    );
    // 实际项目中可调用支付接口，比如调起微信/支付宝支付
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text(widget.orderData.orderTitle),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // 商品列表区域
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
                  // 商品列表
                  Column(
                    children: widget.orderData.goodsList.map((goods) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 商品图片
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
                            // 商品信息
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 商品名称（最多2行）
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
                                  // 价格+折扣+数量
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

            // 优惠券选择区域
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
                  // 优惠券标题
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
                      Text(
                        '共${widget.orderData.couponList.length - 1}张可用',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 优惠券下拉选择框
                  DropdownButtonFormField<CouponModel>(
                    value: _selectedCoupon,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: widget.orderData.couponList.map((coupon) {
                      return DropdownMenuItem(
                        value: coupon,
                        child: Text(
                          coupon.couponName,
                          style: const TextStyle(fontSize: 15, color: Color(0xff333333)),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _onCouponChanged(value);
                      }
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xff666666),
                    ),
                    isExpanded: true,
                  ),
                ],
              ),
            ),

            // 金额汇总区域
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
                  // 商品总价
                  _buildAmountRow('商品总价', '¥${widget.orderData.amountInfo.totalGoodsPrice.toStringAsFixed(2)}'),
                  // 优惠折扣
                  _buildAmountRow('优惠折扣', '-¥${widget.orderData.amountInfo.totalDiscountPrice.toStringAsFixed(2)}'),
                  // 优惠券抵扣
                  _buildAmountRow('优惠券抵扣', '-¥${_selectedCoupon.couponValue.toStringAsFixed(2)}'),
                  // 实付金额
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
      // 底部支付按钮
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

  // 构建金额行组件
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