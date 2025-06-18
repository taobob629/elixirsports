import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base_controller.dart';
import 'empty_view.dart';

abstract class BasePage<C extends BasePageController> extends GetView<C> {
  C createController();

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<C>()) {
      Get.put<C>(createController());
    }

    return Obx(() {
      int pageState = controller.pageState;
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
