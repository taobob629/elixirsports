import 'package:elixir_esports/api/wy_http.dart';
import 'package:elixir_esports/models/order_model.dart';

import '../models/order_detail_model.dart';
import '../models/order_list_model.dart';

class OrderApi {
  static Future<OrderListModel> list({
    required int pageNum,
    required int pageSize,
  }) async {
    var response = await http.get('app/user/myOrders', queryParameters: {
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
    return OrderListModel.fromJson(response.data);
  }

  static Future<OrderDetailModel> storeOrderDetail({
    required var orderId,
  }) async {
    var response =
        await http.get('app/user/storeOrderDetail', queryParameters: {
      "id": orderId,
    });
    return OrderDetailModel.fromJson(response.data);
  }

  /// 根据订单号获取订单数据
  static Future<OrderResponse?> getOrderByOrderId(String orderId) async {
    var response = await http.get('app/scanOrder/getScanOrder', queryParameters: {
      "orderId": orderId,
    });
    return OrderResponse.fromJson(response.data);
  }

  /// 获取用户优惠券列表
  static Future<List<dynamic>> getCustomerCoupon(String orderId) async {
    var response = await http.get('app/scanOrder/getCustomerCoupon', queryParameters: {
      "orderId": orderId,
    });
    return response.data['data'] ?? [];
  }

  /// 使用优惠券
  static Future<Map<String, dynamic>?> useCoupon(String orderId, String couponId) async {
    var response = await http.get('app/scanOrder/useCoupon', queryParameters: {
      "orderId": orderId,
      "couponId": couponId,
    });
    return response.data['data'] ?? {};
  }
}
