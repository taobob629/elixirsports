import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../api/home_api.dart';
import '../models/store_model.dart';
import '../ui/pages/booking/book_seat_page.dart';
import '../ui/pages/online/chat_page.dart';

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
    if (isToOnline) {
      Get.off(() => ChatPage(
            selectedConversation: V2TimConversation(
              conversationID: "c2c_${model.serviceAccount}",
              // 单聊："c2c_${对方的userID}" ； 群聊："group_${groupID}"
              userID: "${model.serviceAccount}",
              // 仅单聊需要此字段，对方userID
              groupID: "",
              // 仅群聊需要此字段，群groupID
              showName: "${model.name}",
              // 顶部 AppBar 显示的标题
              type: 1, // 单聊传1，群聊传2
              // 以上是最简化最基础的必要配置，您还可在此指定更多参数配置，根据 V2TimConversation 的注释
            ),
          ));
      return;
    }
    Get.to(() => BookSeatPage(), arguments: model);
  }
}
