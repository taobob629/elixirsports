import 'package:elixir_esports/api/booking_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/getx_ctr/service_ctr.dart';
import 'package:get/get.dart';

import '../models/booking_detail_model.dart';

class BookDetailCtr extends BasePageController {
  static BookDetailCtr get find => Get.find();

  var showOrderInfo = false.obs;

  var bookingDetailModel = BookingDetailModel(sites: []).obs;

  @override
  void requestData() async {
    bookingDetailModel.value = await BookingApi.bookingDetail(Get.arguments);
  }

  void cancelBooking() async {
    if (!Get.isRegistered<ServiceCtr>()) {
      Get.put(ServiceCtr());
    }
    await ServiceCtr.find.cancelBooking(bookingDetailModel.value.id);
    Get.back();
  }
}
