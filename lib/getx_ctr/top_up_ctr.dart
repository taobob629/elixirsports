import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/dialog/top_up_confirm_dialog.dart';

class TopUpCtr extends BasePageController {
  static TopUpCtr get find => Get.find();

  var currentIndex = (-1).obs;

  TextEditingController inputMoneyCtr = TextEditingController();
  FocusNode inputMoneyFocusNode = FocusNode();

  List<int> moneyList = [5, 10, 20, 30, 50, 100];

  // Add a flag to track if the text is being updated programmatically
  bool _isProgrammaticUpdate = false;

  @override
  void requestData() {
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
      // Select all text when input field gets focus, so typing replaces existing text
      WidgetsBinding.instance.addPostFrameCallback((_) {
        inputMoneyCtr.selection = TextSelection(
          baseOffset: 0,
          extentOffset: inputMoneyCtr.text.length,
        );
      });
    }
  }

  // Method to update input field programmatically
  void updateInputMoney(int amount, int index) {
    _isProgrammaticUpdate = true;
    inputMoneyCtr.text = amount.toString();
    currentIndex.value = index;
    _isProgrammaticUpdate = false;
  }

  void _onTextChanged() {
    // Only clear selection if it's a user input, not a programmatic update
    if (!_isProgrammaticUpdate) {
      // 当用户修改输入框文本时，清除预设金额选择状态
      currentIndex.value = -1;
    }

    // Remove any leading or trailing spaces
    String text = inputMoneyCtr.text.trim();

    // Ensure the input is a valid number
    if (text.isEmpty || int.tryParse(text) == null) {
      // Don't update if it's a programmatic update
      if (!_isProgrammaticUpdate) {
        inputMoneyCtr.value = const TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        );
      }
      return;
    }

    int value = int.parse(text);

    // Ensure the number is within the range 1 to 1000
    if (value < 1) {
      if (!_isProgrammaticUpdate) {
        inputMoneyCtr.value = const TextEditingValue(
          text: '1',
          selection: TextSelection.collapsed(offset: 1),
        );
      }
    } else if (value > 1000) {
      if (!_isProgrammaticUpdate) {
        inputMoneyCtr.value = const TextEditingValue(
          text: '1000',
          selection: TextSelection.collapsed(offset: 4),
        );
      }
    }
  }

  void confirm() async {
    int money;
    // Always prioritize the input field value when currentIndex is -1
    // This ensures that when user inputs a custom amount, that's what gets used
    if (currentIndex.value == -1) {
      if (inputMoneyCtr.text.isEmpty) {
        showToast('Enter the recharge amount'.tr);
        return;
      } else {
        // Parse the input value to ensure it's a valid integer
        money = int.parse(inputMoneyCtr.text);
      }
    } else {
      // Use the selected preset amount
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
