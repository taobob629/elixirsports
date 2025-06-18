import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/dialog/top_up_confirm_dialog.dart';

class TopUpCtr extends BasePageController {
  static TopUpCtr get find => Get.find();

  var currentIndex = 0.obs;

  TextEditingController inputMoneyCtr = TextEditingController();
  FocusNode inputMoneyFocusNode = FocusNode();

  List<int> moneyList = [5, 10, 20, 30, 50, 100];

  @override
  void requestData() async {
    inputMoneyCtr.addListener(_onTextChanged);
    inputMoneyFocusNode.addListener(_onTextFocus);
  }

  @override
  void onClose() {
    inputMoneyCtr.removeListener(_onTextChanged);
    inputMoneyCtr.dispose();
    inputMoneyFocusNode.removeListener(_onTextFocus);
    inputMoneyFocusNode.dispose();
    super.onClose();
  }

  void _onTextFocus() {
    if (inputMoneyFocusNode.hasFocus) {
      currentIndex.value = -1;
    }
  }

  void _onTextChanged() {
    // Remove any leading or trailing spaces
    String text = inputMoneyCtr.text.trim();

    // Ensure the input is a valid number
    if (text.isEmpty || int.tryParse(text) == null) {
      inputMoneyCtr.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }

    int value = int.parse(text);

    // Ensure the number is within the range 1 to 1000
    if (value < 1) {
      inputMoneyCtr.value = const TextEditingValue(
        text: '1',
        selection: TextSelection.collapsed(offset: 1),
      );
    } else if (value > 1000) {
      inputMoneyCtr.value = const TextEditingValue(
        text: '1000',
        selection: TextSelection.collapsed(offset: 4),
      );
    }
  }

  void confirm() async {
    int money;
    if (currentIndex.value == -1) {
      if (inputMoneyCtr.text.isEmpty) {
        showToast('Please Input The Recharge Amount'.tr);
        return;
      } else {
        money = int.parse(inputMoneyCtr.text);
      }
    } else {
      money = moneyList[currentIndex.value];
    }

    final value = await showCustom(
      TopUpConfirmDialog(
        money: money,
        type: 0,
      ),
      alignment: Alignment.bottomCenter,
    );
    if (value != null) {
      Get.back(result: value);
    }
  }
}
