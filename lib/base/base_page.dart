import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base_controller.dart';
import 'empty_view.dart';

abstract class BasePage<C extends BasePageController> extends GetView<C> {
  C createController();

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // 确保控制器在build开始时就被注册
    if (!Get.isRegistered<C>()) {
      Get.put<C>(createController());
    }

    return Obx(() {
      // 使用find方法获取控制器，确保控制器已注册
      final C ctrl = Get.find<C>();
      int pageState = ctrl.pageState;
      switch (pageState) {
        case PageState.empty:
          return EmptyView();
        case PageState.success:
        case PageState.err:
        case PageState.initialing:
        default:
          return buildBody(context);
      }
    });
  }
}
