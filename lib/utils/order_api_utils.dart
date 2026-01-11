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
        Uri.parse('http://146.56.192.175:8091/app/scanOrder/getScanOrder?orderId=$orderId'),
          headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("jsonData:${jsonData}");
        return OrderResponse.fromJson(jsonData);
      } else {
        print('错误，订单接口请求失败：${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('错误网络异常：$e');
      e.printError();
      return null;
    }
  }



  // ===================== 新增优惠券接口 =====================
  /// 获取用户优惠券列表
  static Future<List<dynamic>> getCustomerCoupon(String orderId) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/app/scanOrder/getCustomerCoupon?orderId=$orderId");
      print("${ApiConfig.baseUrl}/app/scanOrder/getCustomerCoupon");

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
  static Future<Map<String, dynamic>?> useCoupon(String orderId, String couponId) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/app/scanOrder/useCoupon?orderId=$orderId&couponId=$couponId");

      final response = await http.get(
        url,
        headers: ApiConfig.defaultHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data.toString());
        return data['data'] ?? {}; // 返回优惠券结果
      } else {
        print('Error: useCoupon API failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: useCoupon API error: $e');
      throw Exception("Failed to use coupon");
    }
  }

}