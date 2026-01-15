import 'package:date_format/date_format.dart';
import 'package:elixir_esports/api/login_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:elixir_esports/ui/pages/main_page.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../models/login_model.dart';
import '../ui/dialog/register_success_dialog.dart';
import '../ui/dialog/select_gender_dialog.dart';
import '../ui/dialog/select_identity_dialog.dart';

import '../ui/widget/date_picker_widget.dart';
import '../utils/storage_manager.dart';

class RegisterNextCtr extends BasePageController {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController genderCtr = TextEditingController();
  TextEditingController birthdayCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController idNumberCtr = TextEditingController();
  TextEditingController identyTypeCtr = TextEditingController();

  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  late Map<String, dynamic> params;

  @override
  void requestData() async {
    params = Get.arguments as Map<String, dynamic>;
  }

  void selectGender() async {
    String? result = await showCustom(
      SelectGenderDialog(),
      alignment: Alignment.bottomCenter,
    );
    if (result != null) {
      genderCtr.text = result;
    }
  }

  void selectIdentity() async {
    String? result = await showCustom(
      SelectIdentityDialog(),
      alignment: Alignment.bottomCenter,
    );
    if (result != null) {
      identyTypeCtr.text = result;
    }
  }

  void selectBirthday() async {
    DateTime? dateTime = await showCustom(
      DatePickerWidget(),
    );
    if (dateTime != null) {
      birthdayCtr.text = formatDate(
        dateTime,
        [yyyy, '-', mm, '-', dd],
      );
    }
  }

  void submit() async {
    if (nameCtr.text.isEmpty) {
      showToast('Please Input Username'.tr);
      return;
    }
    if (genderCtr.text.isEmpty) {
      showToast('Please Select Gender'.tr);
      return;
    }
    if (birthdayCtr.text.isEmpty) {
      showToast('Please Select Birthday'.tr);
      return;
    }
    if (emailCtr.text.isEmpty) {
      showToast('Please Input Your Email'.tr);
      return;
    }
    if (!emailRegex.hasMatch(emailCtr.text)) {
      showToast('Please enter a valid email address'.tr);
      return;
    }
    if (identyTypeCtr.text.isEmpty) {
      showToast('Please Select Identity type'.tr);
      return;
    }
    if (idNumberCtr.text.isEmpty) {
      showToast('Please Input ID NUMBER'.tr);
      return;
    }
    // 收到RegisterCtr传过来的参数
    PhoneNumber phoneNumber = params["phoneNumber"];

    Map<String, dynamic> map = {
      "email": emailCtr.text,
      "nickName": nameCtr.text,
      "gender": genderCtr.text.toLowerCase().contains("male") ? 0 : 1,
      "birth": birthdayCtr.text,
      "password": params["password"],
      "country": phoneNumber.dialCode,
      "identity": idNumberCtr.text.toLowerCase(),
      "identityType": identyTypeCtr.text.toLowerCase().contains("fin")
          ? 3
          : identyTypeCtr.text.toLowerCase().contains("ncr")
              ? 2
              : 0,
    };

    map['phone'] = phoneNumber.parseNumber();
    LoginModel model = await LoginApi.appRegister(map: map);
    if (model.token != null) {
      await showCustom(RegisterSuccessDialog());

      StorageManager.setAccount(phoneNumber.parseNumber());
      StorageManager.setPassword(params['password']);
      StorageManager.setToken(model.token!);
      UserController.find.requestProfileData();
      // UserController.find.imLogin();

      Get.deleteAll();

      Get.offAll(() => MainPage(), arguments: 2);
    }
  }
}
