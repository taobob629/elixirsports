/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'package:elixir_esports/utils/storage_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../lang/translations.dart';
import '../../services/location_service.dart';

class AppController extends GetxController {

  static AppController get find => Get.find();

  @override
  void onInit() {
    super.onInit();

    LocationService().init();

    Get.updateLocale(StorageManager.getLocal() ?? ENGLISH);
    initEasyLoadding();
  }

  initEasyLoadding() {
    // 全局配置SmartDialog的参数
    SmartDialog.config.toast = SmartConfigToast(alignment: Alignment.topCenter);
    SmartDialog.config.loading = SmartConfigLoading(clickMaskDismiss: true);
  }
}
