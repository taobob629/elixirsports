import 'package:elixir_esports/getx_ctr/main_ctr.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../assets_utils.dart';
import '../../base/base_page.dart';

class MainPage extends BasePage<MainCtr> {

  @override
  MainCtr createController() => MainCtr();

  @override
  Widget buildBody(BuildContext context) => WillPopScope(
        onWillPop: () => controller.exitApp(),
        child: Obx(() => Scaffold(
              body: controller.bodys[controller.currentIndex.value],
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex.value,
                onTap: (index) => controller.switchPage(index),
                selectedItemColor: toColor('#3D3D3D'),
                unselectedItemColor: toColor('#3D3D3D'),
                selectedFontSize: 12.sp,
                unselectedFontSize: 12.sp,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      controller.currentIndex.value == 0
                          ? AssetsUtils.home_selected_icon
                          : AssetsUtils.home_normal_icon,
                      width: 26.w,
                      height: 26.w,
                    ),
                    label: 'Home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      controller.currentIndex.value == 1
                          ? AssetsUtils.service_selected_icon
                          : AssetsUtils.service_normal_icon,
                      width: 26.w,
                      height: 26.w,
                    ),
                    label: 'Service'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      controller.currentIndex.value == 2
                          ? AssetsUtils.mine_selected_icon
                          : AssetsUtils.mine_normal_icon,
                      width: 26.w,
                      height: 26.w,
                    ),
                    label: 'Mine'.tr,
                  ),
                ],
              ),
            )),
      );
}
