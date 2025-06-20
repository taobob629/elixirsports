import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/login_api.dart';
import '../utils/count_down_util.dart';

class ForgotPasswordCtr extends BasePageController {
  static ForgotPasswordCtr get find => Get.find();

  TextEditingController emailCtr = TextEditingController();
  TextEditingController newPsdCtr = TextEditingController();
  TextEditingController reNewPsdCtr = TextEditingController();
  TextEditingController codeCtr = TextEditingController();

  String verifyCodeDesc = 'Send'.tr;
  var countTime = 59.obs;
  var showCountDown = false.obs;
  CountDownUtil? countDownUtil;

  String uid = "";

  @override
  void requestData() async {}

  @override
  void onClose() {
    super.onClose();

    if (countDownUtil != null) {
      countDownUtil?.stopCountDown();
    }
  }

  void sendVerifyCode() async {
    if (emailCtr.text.isNotEmpty && !showCountDown.value) {
      String? result = await LoginApi.sendValidCode(emailCtr.text);
      if (result != null) {
        uid = result;
        countTime.refresh();
        countDownUtil = CountDownUtil(
          (int data) {
            showCountDown.value = true;
            countTime.value = data;
          },
          () {
            showCountDown.value = false;
            countDownUtil?.stopCountDown();
            verifyCodeDesc = 'Resend'.tr;
          },
          seconds: 60,
        );
        countDownUtil?.startCountDown();
      }
    }
  }

  void submit() async {
    if (uid.isEmpty) {
      showToast("Please click to send verification code".tr);
      return;
    }
    if (codeCtr.text.isEmpty) {
      showToast("Please enter the verification code".tr);
      return;
    }
    if (codeCtr.text.isEmpty) {
      showToast("Please enter the verification code".tr);
      return;
    }
    if (newPsdCtr.text.isEmpty) {
      showToast("Please enter new password".tr);
      return;
    }
    if (reNewPsdCtr.text.isEmpty) {
      showToast("Please repeat your new password".tr);
      return;
    }
    if (newPsdCtr.text != reNewPsdCtr.text) {
      showToast("The two passwords you entered do not match".tr);
      return;
    }
    Map<String, dynamic> map = {
      "memberCode": emailCtr.text,
      "verifyCode": codeCtr.text,
      "password": newPsdCtr.text,
      "uid": uid,
    };

    bool? verifySuccess =
    await LoginApi.appRegValidCode(code: codeCtr.text, uid: uid!);
    if (verifySuccess != null && verifySuccess) {
      await LoginApi.forgetPassword(map: map);
      showToast('Your password has been successfully changed'.tr);

      Get.back();

    } else {
      showToast('Invalid Verification Code'.tr);
    }
    // int code = await LoginApi.forgetPassword(map: map);
    // if (code == 200) {
    //   Get.back();
    //   showToast("Reset password successfully".tr);
    // } else
    //   showToast("Invalid verification code".tr);
  }
}
