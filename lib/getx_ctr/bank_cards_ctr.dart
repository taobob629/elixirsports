import 'package:elixir_esports/api/booking_api.dart';
import 'package:elixir_esports/api/wallet_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/getx_ctr/service_ctr.dart';
import 'package:elixir_esports/ui/pages/banks/add_bank_cards_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/bank_card_model.dart';
import '../models/booking_detail_model.dart';
import '../ui/dialog/confirm_dialog.dart';

class BankCardsCtr extends BasePageController {

  var currentSelectIndex = 0.obs;

  // 是否显示选中状态
  bool showSelectStatus = false;

  var bankCardList = <BankCardModel>[].obs;

  var showLoading = true.obs;

  @override
  void requestData() async {
    showSelectStatus = Get.arguments;
    bankCardList.value = await WalletApi.getBankCards();
    showLoading.value = false;
  }

  void addBankCards() async {
    await Get.to(() => AddBankCardsPage());
    requestData();
  }

  void deleteBankCard(int i) async {
    final value = await Get.dialog(
      ConfirmDialog(
        title: 'CONFIRM'.tr,
        info: "Are you sure you want to delete this bank card?".tr,
      ),
      barrierColor: Colors.black26,
    );
    if (value != null) {
      await WalletApi.deleteBankCard(id: bankCardList[i].id);
      requestData();
    }
  }
}
