import 'package:elixir_esports/api/wy_http.dart';

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
    required int orderId,
  }) async {
    var response =
        await http.get('app/user/storeOrderDetail', queryParameters: {
      "id": orderId,
    });
    return OrderDetailModel.fromJson(response.data);
  }
}
