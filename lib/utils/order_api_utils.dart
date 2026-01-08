import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../models/order_model.dart'; // 对应之前定义的订单数据模型

class OrderApiUtils {
  /// 根据订单号获取订单数据
  static Future<OrderResponse?> getOrderByOrderId(String orderId) async {
    try {
      // 替换为你的实际订单接口地址，拼接订单号参数
      final response = await http.get(
        Uri.parse('https://your-domain.com/appPayOrder?orderId=$orderId'),
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
}