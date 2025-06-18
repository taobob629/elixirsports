import 'package:elixir_esports/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/booking_api.dart';
import '../api/service_api.dart';
import '../models/booking_detail_model.dart';
import '../ui/dialog/confirm_dialog.dart';

class ServiceCtr extends BasePageController {
  static ServiceCtr get find => Get.find();

  var showOrderInfo = false.obs;

  var bookingDetailModel = BookingDetailModel(sites: []).obs;

  @override
  void requestData() async {
    bookingDetailModel.value = await ServiceApi.getServiceData();
  }

  Future<void> cancelBooking(int? id) async {
    final value = await Get.dialog(
      ConfirmDialog(
        title: 'CONFIRM'.tr,
        info: "Are you sure you want to cancel this reservation?".tr,
      ),
      barrierColor: Colors.black26,
    );
    if (value != null) {
      await BookingApi.cancelBooking(id: id);
      requestData();
    }
  }
}
