import 'package:elixir_esports/base/base_controller.dart';
import 'package:get/get.dart';

import '../api/order_api.dart';
import '../models/order_detail_model.dart';

class OrderDetailCtr extends BasePageController {
  static OrderDetailCtr get find => Get.find();

  var orderDetailModel = OrderDetailModel(items: []).obs;

  @override
  void requestData() async {
    try {
      // 检查orderId是否为空
      if (Get.arguments != null) {
        orderDetailModel.value = await OrderApi.storeOrderDetail(orderId: Get.arguments);
      } else {
        // 如果没有orderId，使用空的OrderDetailModel
        orderDetailModel.value = OrderDetailModel(items: []);
      }
    } catch (e) {
      // 处理API调用错误
      print('Failed to get order detail: $e');
      // 使用空的OrderDetailModel作为默认值
      orderDetailModel.value = OrderDetailModel(items: []);
    }
  }
}
