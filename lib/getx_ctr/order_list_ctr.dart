import 'package:elixir_esports/base/getx_refresh_controller.dart';
import 'package:get/get.dart';

import '../api/order_api.dart';
import '../models/order_list_model.dart';

class OrderListCtr extends GetxRefreshController<OrderRow> {
  static OrderListCtr get find => Get.find();

  @override
  void requestData() {}

  @override
  Future<List<OrderRow>> loadData({int pageNum = 1}) async {
    final model = await OrderApi.list(pageNum: pageNum, pageSize: pageSize);
    if (model.tableDataInfo != null) {
      return model.tableDataInfo!.rows;
    }
    return [];
  }
}
