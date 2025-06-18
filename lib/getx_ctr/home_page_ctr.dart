import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../api/home_api.dart';
import '../api/profile_api.dart';
import '../base/getx_refresh_controller.dart';
import '../models/store_model.dart';
import '../models/version_model.dart';
import '../services/location_service.dart';
import '../ui/dialog/upgrade_dialog.dart';
import '../ui/pages/main/tab_home_page.dart';
import '../ui/pages/main/tab_mine_page.dart';
import '../ui/pages/main/tab_services_page.dart';
import '../utils/toast_utils.dart';

class HomePageCtr extends GetxRefreshController<StoreModel> {
  static HomePageCtr get find => Get.find();

  LocationService locationService = LocationService();

  var currentIndex = 0.obs;
  List<Widget> bodys = [];

  // 位置监听的变量，收到LocationService里面的Getx的position的回调
  late Worker everPosition;

  @override
  Future<List<StoreModel>> loadData({int pageNum = 1}) async {
    final result = await HomeApi.getStoresList();
    return result;
  }

  @override
  void requestData() async {
    bodys.add(TabHomePage());
    bodys.add(TabServicesPage());
    bodys.add(TabMinePage());

    everPosition =
        ever(locationService.position, (Position? pos) => list.refresh());

    checkVersion();
  }

  @override
  void onClose() {
    super.onClose();

    everPosition.dispose();
  }

  void search(String value) async {
    list.value = await HomeApi.search(value);
  }

  void checkVersion() async {
    showLoading();
    VersionModel model = await ProfileApi.checkVersion();
    dismissLoading();
    if (model.upgrade) {
      showCustom(
        UpgradeDialog(model: model),
        clickMaskDismiss: !model.force,
        backType: SmartBackType.block,
      );
    }
  }
}
