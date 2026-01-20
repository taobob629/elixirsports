import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:elixir_esports/base/base_controller.dart';
import '../api/login_api.dart';
import '../api/profile_api.dart';
import '../api/wy_http.dart';
import '../models/version_model.dart';
import '../ui/dialog/confirm_dialog.dart';
import '../ui/dialog/upgrade_dialog.dart';
import '../ui/pages/settings/password_page.dart';
import '../ui/pages/settings/password_page_newUser.dart';
import 'user_controller.dart';
import '../ui/dialog/change_avatar_dialog.dart';
import '../utils/toast_utils.dart';

class SettingsCtr extends BasePageController {
  static SettingsCtr get find => Get.find();

  TextEditingController nameCtr = TextEditingController();

  TextEditingController oldPsdCtr = TextEditingController();
  TextEditingController newPsdCtr = TextEditingController();
  TextEditingController repeatPsdCtr = TextEditingController();

  // 更换手机号相关控制器
  TextEditingController oldCodeCtr = TextEditingController();
  TextEditingController newCodeCtr = TextEditingController();

  // 手机号对象，用于处理国家代码和手机号
  PhoneNumber? oldPhoneNumber;
  PhoneNumber? newPhoneNumber;

  // 验证码倒计时
  RxInt oldCodeCountdown = 0.obs;
  RxInt newCodeCountdown = 0.obs;
  Timer? _oldCodeTimer;
  Timer? _newCodeTimer;

  // 国家列表
  var countries = <String>[].obs;

  @override
  void requestData() async {
    nameCtr.text = UserController.find.profileModel.value.name ?? '';
    countries.value = await LoginApi.getCountry();

    // Set current phone number from UserModel as oldPhoneNumber
    String currentPhone = UserController.find.userModel.value.phone ?? '';
    if (currentPhone.isNotEmpty) {
      // Simplified approach: assume SG country code if not specified
      oldPhoneNumber = PhoneNumber(isoCode: 'SG', phoneNumber: currentPhone);
    }
  }

  @override
  void onClose() {
    // 清理定时器
    _oldCodeTimer?.cancel();
    _newCodeTimer?.cancel();
    super.onClose();
  }

  // 发送老手机号验证码
  void sendOldPhoneCode() async {
    if (oldCodeCountdown.value > 0) return;

    if (oldPhoneNumber == null) {
      showToast("Please enter old phone number".tr);
      return;
    }

    String phone = oldPhoneNumber!.parseNumber();
    if (phone.isEmpty) {
      showToast("Please enter old phone number".tr);
      return;
    }

    showLoading();
    try {
      // 调用发送验证码API
      await LoginApi.sendPhoneCode(phone);
      dismissLoading();

      // 开始倒计时
      _startOldCodeCountdown();
      showToast("Verification code sent successfully".tr);
    } catch (e) {
      dismissLoading();
      showToast("Failed to send verification code".tr);
    }
  }

  // 验证老手机号
  Future<bool> verifyOldPhone() async {
    if (oldPhoneNumber == null) {
      showToast("Please enter old phone number".tr);
      return false;
    }

    String phone = oldPhoneNumber!.parseNumber();
    if (phone.isEmpty) {
      showToast("Please enter old phone number".tr);
      return false;
    }

    if (oldCodeCtr.text.isEmpty) {
      showToast("Please enter verification code".tr);
      return false;
    }

    showLoading();
    try {
      // 调用验证老手机号API
      final response = await http.post('app/user/verifyOldPhone', data: {
        "phone": phone,
        "code": oldCodeCtr.text,
      });
      dismissLoading();
      print("verifyOldPhone response:${response}");

      print("verifyOldPhone response data:${response.data}");
      if (response.data == true) {
        return true;
      } else {
        showToast(response.data['msg'] ?? "Verification failed".tr);
        return false;
      }
    } catch (e) {
      dismissLoading();
      showToast("Verification failed".tr);
      return false;
    }
  }

  // 发送新手机号验证码
  void sendNewPhoneCode() async {
    if (newCodeCountdown.value > 0) return;

    if (newPhoneNumber == null) {
      showToast("Please enter new phone number".tr);
      return;
    }

    String phone = newPhoneNumber!.parseNumber();
    if (phone.isEmpty) {
      showToast("Please enter new phone number".tr);
      return;
    }

    showLoading();
    try {
      // 调用发送验证码API
      await LoginApi.sendPhoneCode(phone);
      dismissLoading();

      // 开始倒计时
      _startNewCodeCountdown();
      showToast("Verification code sent successfully".tr);
    } catch (e) {
      dismissLoading();
      showToast("Failed to send verification code".tr);
    }
  }



  // 更新手机号
  Future<bool> updatePhone() async {
    if (oldPhoneNumber == null) {
      showToast("Please enter old phone number".tr);
      return false;
    }

    if (newPhoneNumber == null) {
      showToast("Please enter new phone number".tr);
      return false;
    }

    String oldPhone = oldPhoneNumber!.parseNumber();
    String newPhone = newPhoneNumber!.parseNumber();

    if (oldPhone.isEmpty) {
      showToast("Please enter old phone number".tr);
      return false;
    }

    if (newPhone.isEmpty) {
      showToast("Please enter new phone number".tr);
      return false;
    }

    if (oldCodeCtr.text.isEmpty) {
      showToast("Please enter old phone verification code".tr);
      return false;
    }

    if (newCodeCtr.text.isEmpty) {
      showToast("Please enter new phone verification code".tr);
      return false;
    }

    showLoading();
    try {
      // 调用更新手机号API
      final response = await http.post('app/user/updatePhone', data: {
        "oldPhone": oldPhone,
        "oldCode": oldCodeCtr.text,
        "newPhone": newPhone,
        "newCode": newCodeCtr.text,
      });
      dismissLoading();

      if (response.data['code'] == 200) {
        // 更新成功，刷新用户信息
        UserController.find.requestProfileData();
        return true;
      } else {
        showToast(response.data['msg'] ?? "Update failed".tr);
        return false;
      }
    } catch (e) {
      dismissLoading();
      showToast("Update failed".tr);
      return false;
    }
  }

  // 开始老手机号验证码倒计时
  void _startOldCodeCountdown() {
    oldCodeCountdown.value = 60;
    _oldCodeTimer?.cancel();
    _oldCodeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (oldCodeCountdown.value > 0) {
        oldCodeCountdown.value--;
      } else {
        _oldCodeTimer?.cancel();
      }
    });
  }

  // 开始新手机号验证码倒计时
  void _startNewCodeCountdown() {
    newCodeCountdown.value = 60;
    _newCodeTimer?.cancel();
    _newCodeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (newCodeCountdown.value > 0) {
        newCodeCountdown.value--;
      } else {
        _newCodeTimer?.cancel();
      }
    });
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
    bool? verifySuccess = await LoginApi.checkOldPwd(code: oldPsdCtr.text);
    if (verifySuccess != null && verifySuccess) {
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
    } else
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
      // showToast("Failed to check password status".tr);
      // 发生错误时默认打开PasswordPage
      Get.to(() => PasswordPage());
    }
  }
}
