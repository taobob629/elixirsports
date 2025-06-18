import 'package:elixir_esports/api/booking_api.dart';
import 'package:elixir_esports/api/wallet_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/getx_ctr/service_ctr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../models/booking_detail_model.dart';
import '../utils/toast_utils.dart';
import '../utils/utils.dart';

class AddBankCardsCtr extends BasePageController {
  // 输入的卡到期日期是否是对的
  var isRightDate = false.obs;
  final MaskTextInputFormatter dateFormatter =
      MaskTextInputFormatter(mask: '##/####', filter: {"#": RegExp(r'[0-9]')});

  // 输入的卡号是否正确
  var isRightCardNo = false.obs;
  final MaskTextInputFormatter cardNoFormatter = MaskTextInputFormatter(
      mask: '####-####-####-####', filter: {"#": RegExp(r'[0-9]')});

  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController emailCtr = TextEditingController();
  final TextEditingController cvvCtr = TextEditingController();
  var isHaveCvv = false.obs;

  var isSaveBankInfo = true.obs;

  @override
  void requestData() {}

  void validateCardNo(String value) {
    try {
      // Parse the date from the cleaned string, using MM/yyyy format.
      String cleanValue = cardNoFormatter.getUnmaskedText();
      if (cleanValue.length < 16) {
        isRightCardNo.value = false;
        return;
      }
      isRightCardNo.value = true;
    } catch (e) {
      isRightCardNo.value = false;
    }
  }

  void validateDate(String value) {
    try {
      // Parse the date from the cleaned string, using MM/yyyy format.
      String cleanValue = dateFormatter.getUnmaskedText();
      if (cleanValue.length < 6) {
        isRightDate.value = false;
        return;
      }

      final int month = int.parse(cleanValue.substring(0, 2));
      final int year = int.parse(cleanValue.substring(2, cleanValue.length));

      // Validate the month is between 1 and 12.
      if (month < 1 || month > 12) {
        isRightDate.value = false;
        return;
      }

      final DateTime inputDate = DateTime(year, month);

      // Get today's date in the same format for comparison.
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month);

      // Check if the input date is after today.
      if (inputDate.isAfter(today)) {
        isRightDate.value = true;
      } else {
        isRightDate.value = false;
      }
    } catch (e) {
      flog(e);
      isRightDate.value = false;
    }
  }

  void payment() async {
    if (!isRightCardNo.value) {
      showToast("Please input your Card Number".tr);
      return;
    }
    if (!isRightDate.value) {
      showToast("Please input your Expiry Date".tr);
      return;
    }
    if (cvvCtr.text.isEmpty) {
      showToast("Please input CVV/CVV2".tr);
      return;
    }
    Map<String, dynamic> map = {
      "cardNumber": cardNoFormatter.getUnmaskedText(),
      "expiryDate": dateFormatter.getMaskedText(),
      "cvv": cvvCtr.text.toString(),
    };
    if (nameCtr.text.isNotEmpty) {
      map["name"] = nameCtr.text.toString();
    }
    if (emailCtr.text.isNotEmpty) {
      map["email"] = emailCtr.text.toString();
    }

    Map<String, dynamic> mapBank = {
      "cardNo": cardNoFormatter.getUnmaskedText(),
      "expiryMonth": int.parse(dateFormatter.getMaskedText().split("/")[0]),
      "expiryYear": int.parse(dateFormatter.getMaskedText().split("/")[1]),
      "securityCode": cvvCtr.text.toString(),
    };
    if (nameCtr.text.isNotEmpty) {
      mapBank["name"] = nameCtr.text.toString();
    }
    if (emailCtr.text.isNotEmpty) {
      mapBank["email"] = emailCtr.text.toString();
    }
    await WalletApi.saveBankInfo(map: mapBank);
    Get.back();
  }
}
