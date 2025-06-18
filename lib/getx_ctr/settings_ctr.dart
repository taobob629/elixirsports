import 'package:elixir_esports/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../api/profile_api.dart';
import '../models/version_model.dart';
import '../ui/dialog/upgrade_dialog.dart';
import 'user_controller.dart';
import '../ui/dialog/change_avatar_dialog.dart';
import '../utils/toast_utils.dart';

class SettingsCtr extends BasePageController {
  static SettingsCtr get find => Get.find();

  TextEditingController nameCtr = TextEditingController();

  TextEditingController oldPsdCtr = TextEditingController();
  TextEditingController newPsdCtr = TextEditingController();
  TextEditingController repeatPsdCtr = TextEditingController();

  @override
  void requestData() {
    nameCtr.text = UserController.find.profileModel.value.name ?? '';
  }

  void updateAvatar() async {
    final path = await showCustom(
      ChangeAvatarDialog(),
      alignment: Alignment.bottomCenter,
    );
    if (path != null) {
      await ProfileApi.updateAvatar(filePath: path);
      UserController.find.requestProfileData();
    }
  }

  void updateUsername() async {
    if (nameCtr.text.isNotEmpty) {
      await ProfileApi.updateUsername(username: nameCtr.text);
      UserController.find.requestProfileData();
      Get.back();
    }
  }

  void changePassword() async {
    if (oldPsdCtr.text.isEmpty) {
      showToast("Please input current password");
      return;
    }
    if (newPsdCtr.text.isEmpty) {
      showToast("Please input new password");
      return;
    }
    if (repeatPsdCtr.text.isEmpty) {
      showToast("Please repeat new password");
      return;
    }
    if (newPsdCtr.text != repeatPsdCtr.text) {
      showToast("The two passwords do not match");
      return;
    }

    if (oldPsdCtr.text.isNotEmpty) {
      await ProfileApi.changePassword(
        oldPwd: oldPsdCtr.text,
        password: newPsdCtr.text,
      );
      oldPsdCtr.text = "";
      newPsdCtr.text = "";
      repeatPsdCtr.text = "";
      UserController.find.requestProfileData();
      Get.back();
    }
  }

  void checkVersion() async {
    showLoading();
    VersionModel model = await ProfileApi.checkVersion();
    dismissLoading();
    if (!model.upgrade) {
      showError("You are using the latest version".tr);
    } else {
      showCustom(
        UpgradeDialog(model: model),
        clickMaskDismiss: !model.force,
        backType: SmartBackType.block,
      );
    }
  }
}
