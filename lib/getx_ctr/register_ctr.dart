import 'package:elixir_esports/api/login_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../ui/pages/login/privacy_check.dart';
import '../ui/pages/login/register_next_page.dart';
import '../utils/count_down_util.dart';

class RegisterCtr extends BasePageController {
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController codeCtr = TextEditingController();

  PhoneNumber? phoneNumber;

  late PrivacyCheckController controller;

  var countries = <String>[].obs;

  String? uid;

  String verifyCodeDesc = 'Send'.tr;
  var countTime = 59.obs;
  var showCountDown = false.obs;
  CountDownUtil? countDownUtil;

  @override
  void requestData() async {
    controller = PrivacyCheckController();

    countries.value = await LoginApi.getCountry();
  }

  @override
  void onClose() {
    super.onClose();

    controller.dispose();
    if (countDownUtil != null) {
      countDownUtil?.stopCountDown();
    }
  }

  void sendVerifyCode() async {
    if (phoneNumber == null) {
      showToast('Please enter your mobile number'.tr);
      return;
    }
    if (phoneNumber!.parseNumber().isEmpty) {
      showToast('Please enter your mobile number'.tr);
      return;
    }
    if (!showCountDown.value) {
      uid = await LoginApi.sendRegValidCode(
        email: phoneNumber!.parseNumber(),
        type: 1,
        country: phoneNumber!.dialCode!,
      );
      if (uid != null) {
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

  void register() async {
    if (!controller.check()) return;
    if (uid == null) {
      showToast('Please click to send verification code'.tr);
      return;
    }
    if (phoneNumber == null) {
      showToast('Please enter your mobile number'.tr);
      return;
    }

    if (phoneNumber!.parseNumber().isEmpty) {
      showToast('Please enter your mobile number'.tr);
      return;
    }
    if (passwordCtr.text.isEmpty) {
      showToast('Please Input Password'.tr);
      return;
    }
    if (codeCtr.text.isEmpty) {
      showToast('Please Input Verification Code'.tr);
      return;
    }

    bool? verifySuccess =
        await LoginApi.appRegValidCode(code: codeCtr.text, uid: uid!);
    if (verifySuccess != null && verifySuccess) {
      Get.to(() => RegisterNextPage(), arguments: {
        "type": 1,
        "phoneNumber": phoneNumber,
        "password": passwordCtr.text,
      });
    } else {
      showToast('Invalid verification Code'.tr);
    }
  }
}
