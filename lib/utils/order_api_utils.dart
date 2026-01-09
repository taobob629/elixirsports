import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../models/order_model.dart'; // 对应之前定义的订单数据模型
import 'ApiConfig.dart';

class OrderApiUtils {
  /// 根据订单号获取订单数据
  static Future<OrderResponse?> getOrderByOrderId(String orderId) async {
    try {
      // 替换为你的实际订单接口地址，拼接订单号参数
      final response = await http.get(
        Uri.parse('http://146.56.192.175:8091/app/home/getScanOrder?orderId=$orderId'),
        headers: {
          'Content-Type': 'application/json',
          // 可添加token等请求头，比如从StorageManager获取
          // 'Authorization': 'Bearer ${StorageManager.getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OrderResponse.fromJson(jsonData);
      } else {
        Get.snackbar('错误', '订单接口请求失败：${response.statusCode}');
        return null;
      }
    } catch (e) {
      Get.snackbar('错误', '网络异常：$e');
      return null;
    }
  }



  // ===================== 新增优惠券接口 =====================
  /// 获取用户优惠券列表
  /// 接口地址：/app/home/getCustomerCoupon
  static Future<List<dynamic>> getCustomerCoupon() async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/app/home/getCustomerCoupon");
      print("${ApiConfig.baseUrl}/app/home/getCustomerCoupon");

      final response = await http.get(
        url,
        headers: ApiConfig.defaultHeaders,
      );
      final data = json.decode(response.body);

      print(data.toString());
      return data['data'] ?? []; // 返回优惠券列表（空数组兜底）
    } catch (e) {
      throw Exception("Failed to load coupons");
    }
  }

  /// 使用优惠券
  /// 接口地址：/app/home/useCoupon?couponId=xxx
  /// [couponId] 优惠券ID
  static Future<Map<String, dynamic>> useCoupon(String couponId) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/app/home/useCoupon?couponId=$couponId");
      final response = await http.get(
        url,
        headers: ApiConfig.defaultHeaders,
      );
      final data = json.decode(response.body);
      return data['data'] ?? {}; // 返回使用结果（空对象兜底）
    } catch (e) {
      throw Exception("Failed to apply coupon");
    }
  }

}