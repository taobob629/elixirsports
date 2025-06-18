import 'package:elixir_esports/base/base_controller.dart';
import 'package:get/get.dart';

import '../api/order_api.dart';
import '../models/order_detail_model.dart';

class OrderDetailCtr extends BasePageController {
  static OrderDetailCtr get find => Get.find();

  var orderDetailModel = OrderDetailModel(items: []).obs;

  @override
  void requestData() async {
    orderDetailModel.value =
        await OrderApi.storeOrderDetail(orderId: Get.arguments);
  }
}
