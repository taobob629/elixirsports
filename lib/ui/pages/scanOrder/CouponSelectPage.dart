import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../../utils/order_api_utils.dart';

// 优惠券模型（保留）
class SelectCouponModel {
  final String couponId;
  final String name;
  final String expireTime;
  final double discountAmount;
  final String? useDesc;
  bool isSelected;

  SelectCouponModel({
    required this.couponId,
    required this.name,
    required this.expireTime,
    required this.discountAmount,
    this.useDesc,
    this.isSelected = false,
  });
}

class CouponSelectPage extends StatefulWidget {
  const CouponSelectPage({super.key});

  @override
  State<CouponSelectPage> createState() => _CouponSelectPageState();
}

class _CouponSelectPageState extends State<CouponSelectPage> {
  List<SelectCouponModel> _couponList = [];
  bool _isLoading = true;
  String? _selectedCouponId;

  @override
  void initState() {
    super.initState();
    _fetchCouponList();
  }

  Future<void> _fetchCouponList() async {
    try {
      SmartDialog.showLoading(msg: "Loading coupons...".tr);
      // 调用整合后的接口
      final response = await OrderApiUtils.getCustomerCoupon();
      _couponList = response.map((item) => SelectCouponModel(
        couponId: item['couponId'] ?? '',
        name: item['name'] ?? '',
        expireTime: item['expireTime'] ?? '',
        discountAmount: double.tryParse(item['discountAmount'].toString()) ?? 0.0,
        useDesc: item['useDesc'],
      )).toList();
      if (_couponList.isNotEmpty) {
        _couponList.first.isSelected = true;
        _selectedCouponId = _couponList.first.couponId;
      }
    } catch (e) {
      debugPrint('获取优惠券失败：$e');
      showError(e.toString());
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
      setState(() => _isLoading = false);
    }
  }

  /// 确认使用优惠券（改为调用OrderApiUtils）
  Future<void> _confirmUseCoupon() async {
    if (_selectedCouponId == null) {
      showToast("Please select a coupon".tr);
      return;
    }

    try {
      SmartDialog.showLoading(msg: "Applying coupon...".tr);
      // 调用整合后的接口
      final response = await OrderApiUtils.useCoupon(_selectedCouponId!);
      final usedCouponId = response['couponId'] ?? '';
      final discountAmount = double.tryParse(response['discountAmount'].toString()) ?? 0.0;
      Get.back(result: {
        'couponId': usedCouponId,
        'discountAmount': discountAmount,
      });
      // showToast("Coupon applied successfully".tr);
    } catch (e) {
      debugPrint('使用优惠券失败：$e');
      showError(e.toString());
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  // 以下_selectCoupon、build、_buildBody、_buildCouponItem方法完全保留，无修改
  void _selectCoupon(int index) {
    setState(() {
      for (var i = 0; i < _couponList.length; i++) {
        _couponList[i].isSelected = (i == index);
      }
      _selectedCouponId = _couponList[index].couponId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Select Coupon".tr,
          style: TextStyle(
            fontSize: 17.sp,
            color: toColor('#333333'),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff333333)),
          onPressed: () => Get.back(),
        ),
        // 移除顶部的确认按钮
        actions: const [],
      ),
      // 核心修改：使用Stack+Column实现底部固定按钮，列表可滚动
      body: Stack(
        children: [
          // 1. 优惠券列表（占满屏幕，底部留按钮空间）
          Padding(
            padding: EdgeInsets.only(bottom: 60.h), // 给底部按钮留50h高度+10h间距
            child: _buildBody(),
          ),
          // 2. 底部固定确认按钮 - 修复color和decoration冲突问题
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              // 核心修复：删除单独的color属性，将颜色移到decoration中
              decoration: BoxDecoration(
                color: Colors.white, // 原color属性移到这里
                border: Border(top: BorderSide(color: toColor('#EEEEEE'), width: 1.w)),
              ),
              child: ElevatedButton(
                onPressed: _selectedCouponId != null ? _confirmUseCoupon : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(1.sw, 48.h),
                  backgroundColor: _selectedCouponId != null ? toColor('#1890ff') : toColor('#cccccc'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Confirm".tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_couponList.isEmpty) {
      return Center(
        child: Text(
          "No available coupons".tr,
          style: TextStyle(fontSize: 14.sp, color: toColor('#999999')),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: _couponList.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) => _buildCouponItem(index),
    );
  }

  Widget _buildCouponItem(int index) {
    final coupon = _couponList[index];
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white, // 优惠券卡片背景色移到decoration中
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: coupon.isSelected ? toColor('#1890ff') : toColor('#EEEEEE'),
          width: coupon.isSelected ? 2.w : 1.w,
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: InkWell(
        onTap: () => _selectCoupon(index),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  coupon.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: toColor('#333333'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "¥${coupon.discountAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: toColor('#EA0000'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "Valid until: ${coupon.expireTime}".tr,
              style: TextStyle(fontSize: 12.sp, color: toColor('#999999')),
            ),
            SizedBox(height: 8.h),
            if (coupon.useDesc != null && coupon.useDesc!.isNotEmpty)
              Text(
                coupon.useDesc!,
                style: TextStyle(fontSize: 12.sp, color: toColor('#666666')),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                coupon.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: coupon.isSelected ? toColor('#1890ff') : toColor('#cccccc'),
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}