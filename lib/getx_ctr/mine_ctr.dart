import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/dialog/input_dialog.dart';
import '../ui/pages/developer/developer_page.dart';
import '../ui/pages/online/conversation_list_page.dart';
import '../ui/pages/store/select_store_page.dart';
import '../ui/pages/wallet/wallet_page.dart';

class MineCtr extends BasePageController {
  int devCount = 0;

  @override
  void requestData() {}

  void jumpChat() async {
    if (UserController.find.profileModel.value.isServiceAccount == false) {
      Get.to(() => SelectStorePage(), arguments: true);
      return;
    }
    Get.to(() => ConversationListPage());
  }

  void toWalletPage() async {
    await Get.to(() => WalletPage());
    UserController.find.requestProfileData();
  }

  void goDev() {
    devCount++;
    if (devCount < 6) {
      return;
    }
    devCount = 0;

    Get.dialog(
      InputDialog(),
      barrierDismissible: true,
      barrierColor: Colors.black26,
    ).then((value) {
      if (value == "9637") {
        Get.to(() => DeveloperPage());
      } else {
        Get.back();
      }
    });
  }
}
