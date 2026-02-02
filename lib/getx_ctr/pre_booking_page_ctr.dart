import 'package:elixir_esports/api/scan_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/getx_ctr/service_ctr.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/booking_api.dart';
import '../models/booking_pre_model.dart';
import '../models/scan_model.dart';
import '../ui/dialog/confirm_dialog.dart';
import '../ui/pages/booking/book_detail_page.dart';

class PreBookingPageCtr extends BasePageController {
  static PreBookingPageCtr get find => Get.find();

  var showStatus = false.obs;
  var isLoading = false.obs; // 添加加载状态标志

  late BookingPreModel preModel;

  @override
  void requestData() {
    preModel = Get.arguments as BookingPreModel;
  }

  void bookNext() async {
    // 防止用户快速点击导致多次触发
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      // ScanModel model=await ScanApi.scanLogin(ip: scanModel.ip, storeId: scanModel.storeId,type:scanModel.type,deviceKey: scanModel.deviceKey);
      final result = await BookingApi.submitBooking(
        storeId: preModel.storeId,
        areaId: preModel.areaId,
        computers: preModel.computers??[],
      );
      if (result.id != null) {
        if (Get.isRegistered<ServiceCtr>()) {
          ServiceCtr.find.requestData();
        }
        Get.offUntil(
          GetPageRoute(
            settings: RouteSettings(arguments: result.id),
            page: () => BookDetailPage(),
          ),
              (route) => route.isFirst,
        );
      // Get.off(() => OrderDetailPage());
    }
    }catch (e) {
      // 捕获异常，避免崩溃
      // showInfo('Login failed. Please try again.'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void bookASeat(BuildContext context) async {
    // 弹出弹窗
    final value = await Get.dialog(
      ConfirmDialog(
        title: 'CONFIRM'.tr,
        htmlString: preModel.htmlString, info: '',
      ),
      barrierColor: Colors.black26,
    );
    if (value == null) return;

    // 确认预约座位的逻辑
    // 这里可以添加预约座位的API调用
  }
}
