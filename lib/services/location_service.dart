/*
  location_service
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class LocationService {
// 工厂方法构造函数 - 通过UserModel()获取对象1
  factory LocationService() => _getInstance();

  // instance的getter方法 - 通过UserModel.instance获取对象2
  static LocationService get instance => _getInstance();

  // 静态变量_instance，存储唯一对象
  static LocationService? _instance;

  // 获取唯一对象
  static LocationService _getInstance() {
    _instance ??= LocationService._internal();
    return _instance!;
  }

  //初始化...
  LocationService._internal() {}
  StreamSubscription<Position>? positionStream;
  Rx<Position?> position = Rx<Position?>(null);

  init() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position.value = await Geolocator.getCurrentPosition();
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? pos) {
      position.value = pos;
      flog('position: 位置更新了：$position');
    });
    flog('position: 最开始的位置：$position');
  }

  dispose() {
    positionStream?.cancel();
  }
}
