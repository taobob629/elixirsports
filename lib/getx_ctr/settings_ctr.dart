import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/ui/pages/login/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:elixir_esports/ui/pages/settings/password_page.dart';
import 'package:elixir_esports/ui/pages/settings/password_page_newUser.dart';
import '../api/login_api.dart';
import '../api/profile_api.dart';
import '../models/version_model.dart';
import '../ui/dialog/confirm_dialog.dart';
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
  Future<void> deleteUser() async {
    final value = await Get.dialog(
      ConfirmDialog(
        title: 'CONFIRM'.tr,
        info: "Are you sure to delete your account?".tr,
      ),
      barrierColor: Colors.black26,
    );
    if (value != null) {
     await UserController.find.deleteUser();
    }
  }

  void changePassword() async {
    if (oldPsdCtr.text.isEmpty) {
      showToast("Please input current password".tr);
      return;
    }
    if (newPsdCtr.text.isEmpty) {
      showToast("Please input new password".tr);
      return;
    }
    if (repeatPsdCtr.text.isEmpty) {
      showToast("Please repeat new password".tr);
      return;
    }
    if (newPsdCtr.text != repeatPsdCtr.text) {
      showToast("The passwords you entered twice do not match".tr);
      return;
    }
    bool? verifySuccess =
    await LoginApi.checkOldPwd(code: oldPsdCtr.text);
    if(verifySuccess!=null&&verifySuccess){
      if (oldPsdCtr.text.isNotEmpty) {
        await ProfileApi.changePassword(
          oldPwd: oldPsdCtr.text,
          password: newPsdCtr.text,
        );
        oldPsdCtr.text = "";
        newPsdCtr.text = "";
        repeatPsdCtr.text = "";
        UserController.find.requestProfileData();
        showToast('Your password has been successfully changed'.tr);

        Get.back();
      }
    }else
      showToast("Incorrect password".tr);

  }
  void setPassword() async {
    if (newPsdCtr.text.isEmpty) {
      showToast("Please input password".tr);
      return;
    }
    if (repeatPsdCtr.text.isEmpty) {
      showToast("Please repeat password".tr);
      return;
    }
    if (newPsdCtr.text != repeatPsdCtr.text) {
      showToast("The passwords you entered twice do not match".tr);
      return;
    }
    await LoginApi.setPassword(password: newPsdCtr.text);
    Get.back();


  }
  void checkVersion() async {
    showLoading();
    VersionModel model = await ProfileApi.checkVersion();
    dismissLoading();
    if (!model.upgrade) {
      showToast("You are using the latest version".tr);
    } else {
      showCustom(
        UpgradeDialog(model: model),
        clickMaskDismiss: !model.force,
        backType: SmartBackType.block,
      );
    }
  }

  void handlePasswordTap() async {
    showLoading();
    try {
      final bool hasPassword = await LoginApi.checkPassword();
      dismissLoading();
      if (hasPassword) {
        // 如果接口返回true，打开PasswordPageNewuser
        Get.to(() => PasswordPageNewuser());
      } else {
        // 其他情况打开PasswordPage
        Get.to(() => PasswordPage());
      }
    } catch (e) {
      dismissLoading();
      showToast("Failed to check password status".tr);
      // 发生错误时默认打开PasswordPage
      Get.to(() => PasswordPage());
    }
  }
}
