import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/getx_ctr/service_ctr.dart';
import 'package:elixir_esports/ui/pages/login/login_page.dart';
import 'package:elixir_esports/utils/storage_manager.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../api/home_api.dart';
import '../models/store_model.dart';
import '../services/location_service.dart';
import '../ui/pages/main/tab_home_page.dart';
import '../ui/pages/main/tab_mine_page.dart';
import '../ui/pages/main/tab_services_page.dart';
import '../utils/platform_utils.dart';
import '../utils/utils.dart';

class MainCtr extends BasePageController {
  static MainCtr get find => Get.find();

  LocationService locationService = LocationService();

  var currentIndex = 0.obs;
  List<Widget> bodys = [];

  DateTime? lastPopTime;

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
  }

  void switchPage(int index) async {
    if (index == 2) {
      if (StorageManager.getToken().isEmpty) {
        Get.to(() => LoginPage());
        return;
      }
      UserController.find.requestProfileData();
    } else if (index == 1) {
      if (Get.isRegistered<ServiceCtr>()) {
        ServiceCtr.find.requestData();
      }
    }
    currentIndex.value = index;
  }

  String showOpenTime(String? openTime) {
    if (openTime == null) {
      return "";
    }
    Map<String, dynamic> weekDays = jsonDecode(openTime);

    String week = formatDate(DateTime.now(), [DD]);
    return weekDays[week];
  }

  String getDistance(String? map) {
    if (map == null) {
      return "0m";
    }
    List<String> latLog = map.replaceAll(" ", "").split(",");
    flog('position: 获取到的位置：${locationService.position}');

    // 新加坡的经纬度（1.3521,103.8198）
    double distance = Geolocator.distanceBetween(
      locationService.position.value?.latitude ?? 1.3521,
      locationService.position.value?.longitude ?? 103.8198,
      double.parse(latLog[0]),
      double.parse(latLog[1]),
    );

    return distance >= 1000
        ? "${(distance / 1000).toStringAsFixed(2)}km"
        : "${distance.toStringAsFixed(2)}m";
  }

  Future<bool> exitApp() async {
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime!) > const Duration(seconds: 2)) {
      lastPopTime = DateTime.now();
      showToast("Press again to exit".tr);
    } else {
      lastPopTime = DateTime.now();
      // 退出app
      // await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      exit(0);
    }
    return false;
  }
}
