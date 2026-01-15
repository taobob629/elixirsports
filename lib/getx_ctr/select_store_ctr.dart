import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:get/get.dart';

import '../api/home_api.dart';
import '../models/store_model.dart';
import '../ui/pages/booking/book_seat_page.dart';

class SelectStoreCtr extends BasePageController {
  var storeList = <StoreModel>[].obs;

  // 是否跳转去在线客服页面
  bool isToOnline = false;

  @override
  void requestData() async {
    isToOnline = Get.arguments ?? false;
    storeList.value = await HomeApi.getStoresList();
  }

  void search(String value) async {
    storeList.value = await HomeApi.search(value);
  }

  void bookSeat(StoreModel model) async {
    if (model.id == null) {
      showToast("Please select a store".tr);
      return;
    }
    Get.to(() => BookSeatPage(), arguments: model);
  }
}
