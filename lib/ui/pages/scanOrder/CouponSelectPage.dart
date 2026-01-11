import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../../api/order_api.dart';

// 优惠券模型（保留）
class SelectCouponModel {
  final String couponId;
  final String name;
  final String expireTime;
  final double couponDiscount;
  final String? useDesc;
  bool isSelected;

  SelectCouponModel({
    required this.couponId,
    required this.name,
    required this.expireTime,
    required this.couponDiscount,
    this.useDesc,
    this.isSelected = false,
  });
}

class CouponSelectPage extends StatefulWidget {
  final String orderId;

  const CouponSelectPage({
    super.key,
    required this.orderId,
  });

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

  // 核心修复：增加接口返回值校验 + 异常兜底
  Future<void> _fetchCouponList() async {
    try {
      SmartDialog.showLoading(msg: "Loading coupons...".tr);
      // 调用接口
      final response = await OrderApi.getCustomerCoupon(widget.orderId);

      // 关键修复1：校验response是否为List，非List则置为空列表
      if (response == null || response is! List) {
        _couponList = [];
        showToast("No coupons available".tr);
        return;
      }

      // 关键修复2：遍历前先过滤空item，避免解析null报错
      _couponList = response.where((item) => item != null).map((item) {
        // 安全解析每个字段，避免null报错
        String couponId = item['couponId']?.toString() ?? '';
        String name = item['name']?.toString() ?? 'Unnamed coupon'.tr;
        String expireTime =
            item['expireTime']?.toString() ?? 'No expiration date'.tr;
        double couponDiscount =
            double.tryParse(item['couponDiscount'].toString()) ?? 0.0;
        String? useDesc = item['useDesc']?.toString();

        return SelectCouponModel(
          couponId: couponId,
          name: name,
          expireTime: expireTime,
          couponDiscount: couponDiscount,
          useDesc: useDesc,
        );
      }).toList();

      // 选中第一个优惠券（仅当列表非空时）
      if (_couponList.isNotEmpty) {
        _couponList.first.isSelected = true;
        _selectedCouponId = _couponList.first.couponId;
      }
    } catch (e) {
      debugPrint('获取优惠券失败：$e');
      // 关键修复3：替换未定义的showError，改用toast提示
      showToast("Failed to load coupons: ${e.toString()}".tr);
      _couponList = []; // 兜底置空，避免后续逻辑报错
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
      setState(() => _isLoading = false);
    }
  }

  /// 确认使用优惠券（修复无意义的dismiss + 严谨的空值判断）
  Future<void> _confirmUseCoupon() async {
    // 1. 基础校验：确保选中了优惠券
    if (_selectedCouponId == null || _couponList.isEmpty) {
      showToast("Please select a coupon".tr);
      return;
    }

    try {
      // 显示加载状态
      SmartDialog.showLoading(msg: "Applying coupon...".tr);

      // 2. 根据选中的couponId找到对应的优惠券对象
      SelectCouponModel selectedCoupon = _couponList.firstWhere(
        (coupon) => coupon.couponId == _selectedCouponId,
        // 兜底返回空优惠券（避免firstWhere抛错）
        orElse: () => SelectCouponModel(
          couponId: "",
          name: "",
          expireTime: "",
          couponDiscount: 0.0,
        ),
      );

      // 3. 调用useCoupon API
      final couponResult =
          await OrderApi.useCoupon(widget.orderId, selectedCoupon.couponId);

      // 4. 隐藏加载状态
      SmartDialog.dismiss(status: SmartStatus.loading);

      // 5. 仅当优惠券ID非空且API调用成功时返回结果
      if (selectedCoupon.couponId.isNotEmpty && couponResult != null) {
        Get.back(result: {
          'couponId': selectedCoupon.couponId,
          'discountAmount': selectedCoupon.couponDiscount,
          'couponName': selectedCoupon.name,
          'memberDiscountPrice':
              double.tryParse(couponResult['memberDiscountPrice'].toString()) ??
                  0.0,
          'tax': double.tryParse(couponResult['tax'].toString()) ?? 0.0,
          'service': double.tryParse(couponResult['service'].toString()) ?? 0.0,
          'subTotal':
              double.tryParse(couponResult['subTotal'].toString()) ?? 0.0,
          'couponDiscount':
              double.tryParse(couponResult['couponDiscount'].toString()) ?? 0.0,
        });
        // showToast("Coupon selected successfully".tr);
      } else {
        showToast("Failed to apply coupon".tr);
      }
    } catch (e) {
      // 隐藏加载状态
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  // 优化选中逻辑：增加空列表判断
  void _selectCoupon(int index) {
    if (_couponList.isEmpty) return;
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
        actions: const [],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 60.h),
            child: _buildBody(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: toColor('#EEEEEE'), width: 1.w)),
              ),
              child: ElevatedButton(
                onPressed: _selectedCouponId != null ? _confirmUseCoupon : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(1.sw, 48.h),
                  backgroundColor: _selectedCouponId != null
                      ? toColor('#1890ff')
                      : toColor('#cccccc'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "CONFIRM".tr,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard, size: 60.w, color: toColor('#999999')),
            SizedBox(height: 10.h),
            Text(
              "No available coupons".tr,
              style: TextStyle(fontSize: 14.sp, color: toColor('#999999')),
            ),
          ],
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
        color: Colors.white,
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
                  "S\$${coupon.couponDiscount.toStringAsFixed(2)}",
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
              "${"Valid until:".tr} ${coupon.expireTime}",
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
                coupon.isSelected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color:
                    coupon.isSelected ? toColor('#1890ff') : toColor('#cccccc'),
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
