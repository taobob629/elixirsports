import 'package:elixir_esports/base/getx_refresh_controller.dart';
import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:get/get.dart';

import '../api/wallet_api.dart';
import '../models/wallet_model.dart';
import '../ui/pages/wallet/top_up_page.dart';

class WalletCtr extends GetxRefreshController<WalletRow> {
  static WalletCtr get find => Get.find();

  var walletModel = WalletModel(reward: '0', cash: '0').obs;
  var oldWalletModel = WalletModel(reward: '0', cash: '0').obs;

  var showLoading = true.obs;

  // 动画显示状态
  var showAnimator = false.obs;

  @override
  void requestData() {}

  @override
  Future<List<WalletRow>> loadData({int pageNum = 1}) async {
    // 保存旧值
    oldWalletModel.value = walletModel.value;

    // 调用mywallet接口获取新值
    var newWalletModel =
        await WalletApi.list(pageNum: pageNum, pageSize: pageSize);
    showLoading.value = false;

    // 比较新旧值，决定是否触发动画
    // 仅当当前有值且新旧值不同时触发动画
    bool hasOldCash = oldWalletModel.value.cash.isNotEmpty &&
        oldWalletModel.value.cash != '0';
    bool hasOldReward = oldWalletModel.value.reward.isNotEmpty &&
        oldWalletModel.value.reward != '0';
    bool cashChanged =
        hasOldCash && oldWalletModel.value.cash != newWalletModel.cash;
    bool rewardChanged =
        hasOldReward && oldWalletModel.value.reward != newWalletModel.reward;

    showAnimator.value = cashChanged || rewardChanged;

    // 更新当前值
    walletModel.value = newWalletModel;

    // 如果有动画，延迟后重置动画状态（确保延迟大于动画持续时间）
    if (showAnimator.value) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        showAnimator.value = false;
      });
    }

    if (walletModel.value.cashRecord != null) {
      return walletModel.value.cashRecord!.rows;
    }
    return [];
  }

  void topUp() async {
    if (UserController.find.profileModel.value.topup == true) {
      await Get.to(() => TopUpPage());
      // 充值完成后刷新钱包数据，触发动画
      await onRefresh();
    }
  }
}
