import 'package:elixir_esports/api/scan_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:get/get.dart';

import '../models/scan_model.dart';

class ScanToUnlockCtr extends BasePageController {

  static ScanToUnlockCtr get find => Get.find();

  var showStatus = false.obs;

  late ScanModel scanModel;

  @override
  void requestData() {
    scanModel = Get.arguments as ScanModel;
  }

  void loginNext() async {
    ScanModel model=await ScanApi.scanLogin(ip: scanModel.ip, storeId: scanModel.storeId);
    showToast(model.msg);
    // Get.off(() => OrderDetailPage());
  }
}