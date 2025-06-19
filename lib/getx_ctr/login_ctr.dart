import 'package:elixir_esports/api/login_api.dart';
import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/ui/pages/main_page.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:elixir_esports/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/login_model.dart';
import '../ui/pages/login/privacy_check.dart';
import '../utils/storage_manager.dart';

class LoginCtr extends BasePageController {
  static LoginCtr get find => Get.find();

  TextEditingController usernameCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  late PrivacyCheckController controller;

  @override
  void onInit() {
    super.onInit();

    controller = PrivacyCheckController();
  }

  @override
  void requestData() async {
    usernameCtr.text = StorageManager.getAccount();
    passwordCtr.text = StorageManager.getPassword();
    flog("password = ${passwordCtr.text}");
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void login() async {
    if (controller.check()) {
      if (usernameCtr.text.toString().isEmpty) {
        showToast("Please input account".tr);
        return;
      }
      if (passwordCtr.text.toString().isEmpty) {
        showToast("Please input password".tr);
        return;
      }
      LoginModel model = await LoginApi.login(
          usernameCtr.text.toString(), passwordCtr.text.toString());
      if (model.token != null) {
        StorageManager.setAccount(usernameCtr.text.toString());
        StorageManager.setPassword(passwordCtr.text.toString());
        StorageManager.setToken(model.token!);
        UserController.find.requestProfileData();
        UserController.find.imLogin();
        Get.deleteAll();

        Get.offAll(() => MainPage());
      }
    }
  }
}
