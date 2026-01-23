import 'package:elixir_esports/api/scan_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:get/get.dart';

import '../models/scan_model.dart';

class ScanToUnlockCtr extends BasePageController {

  static ScanToUnlockCtr get find => Get.find();

  var showStatus = false.obs;
  var isLoading = false.obs; // 添加加载状态标志

  late ScanModel scanModel;

  @override
  void requestData() {
    scanModel = Get.arguments as ScanModel;
  }

  void loginNext() async {
    // 防止用户快速点击导致多次触发
    if (isLoading.value) return;
    
    isLoading.value = true;
    
    try {
      ScanModel model=await ScanApi.scanLogin(ip: scanModel.ip, storeId: scanModel.storeId,type:scanModel.type,deviceKey: scanModel.deviceKey);
      
      // Get.off(() => OrderDetailPage());
    } catch (e) {
      // 捕获异常，避免崩溃
      // showInfo('Login failed. Please try again.'.tr);
    } finally {
      isLoading.value = false;
    }
  }
}