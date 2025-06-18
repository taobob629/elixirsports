import 'package:elixir_esports/base/getx_refresh_controller.dart';
import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:get/get.dart';

import '../api/wallet_api.dart';
import '../models/wallet_model.dart';
import '../ui/pages/wallet/top_up_page.dart';

class WalletCtr extends GetxRefreshController<WalletRow> {
  static WalletCtr get find => Get.find();

  var walletModel = WalletModel(reward: '0', cash: '0').obs;

  var showLoading = true.obs;

  // 上一次的金额
  var showAnimator = false.obs;

  @override
  void requestData() {}

  @override
  Future<List<WalletRow>> loadData({int pageNum = 1}) async {
    walletModel.value = await WalletApi.list(pageNum: pageNum, pageSize: pageSize);
    showLoading.value = false;
    if (walletModel.value.cashRecord != null) {
      return walletModel.value.cashRecord!.rows;
    }
    return [];
  }

  void topUp() async {
    // if (UserController.find.profileModel.value.topup == true) {
    await Get.to(() => TopUpPage());
    await onRefresh();
    // }
  }
}
