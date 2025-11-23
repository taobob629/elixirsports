import 'package:elixir_esports/models/ad_model.dart';
import 'package:elixir_esports/ui/pages/member/members_page.dart';
import 'package:elixir_esports/ui/pages/store/select_store_page.dart';
import 'package:elixir_esports/ui/pages/wallet/top_up_page.dart';
import 'package:elixir_esports/ui/pages/wallet/wallet_page.dart';
import 'package:elixir_esports/utils/image_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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

    everPosition = ever(locationService.position, (Position? pos) => list.refresh());

    checkVersion();
    checkAdPromote();
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

  void checkAdPromote() async {
    AdModel model = await ProfileApi.checkAdPromote();
    if (model.image.isNotEmpty) {
      Get.dialog(Center(
        child: GestureDetector(
          onTap: () {
            Get.back();
            handleAdPromote(model);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(model.title),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ImageUtil.networkImage(url: model.image),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: const Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
  }

  void handleAdPromote(AdModel model) {
    ProfileApi.clickPromote(model);
    switch (model.type) {
      case 'H5':
        canLaunchUrl(Uri.parse(model.target)).then((val) {
          launchUrl(Uri.parse(model.target));
        });
        break;
      case 'page':
        switch(model.target){
          case "TopUp":
            Get.to(() => TopUpPage(message: model.msg));
            break;
          case 'Bookings':
            Get.to(() => SelectStorePage());
            break;
          case 'Points':
            Get.to(() => WalletPage());
            break;
          case 'ElixirCard':
            Get.to(() => MemberPage());
            break;
          default:
            break;
        }
      default:
        break;
    }
  }
}
