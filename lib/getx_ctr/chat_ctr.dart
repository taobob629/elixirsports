import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../base/base_controller.dart';

class ChatController extends BasePageController {
  V2TimConversation selectedConversation;

  ChatController(this.selectedConversation);

  var count = 0.obs;

  @override
  void requestData() {
    if (selectedConversation.type == 1) {
      popPrivateMenus.clear();
      popPrivateMenus.add('Block');
      return;
    }
  }

  final Rxn _memberInfo = Rxn<V2TimGroupInfo?>();

  V2TimGroupInfo get memberInfo => _memberInfo.value;

  set memberInfo(V2TimGroupInfo? value) {
    _memberInfo.value = value;
  }

  // ///未定义（没有获取该字段）
  // ///
  // static const int V2TIM_GROUP_MEMBER_UNDEFINED = 0;
  // ///群成员
  // ///
  // static const int V2TIM_GROUP_MEMBER_ROLE_MEMBER = 200;
  // ///群管理员
  // ///
  // static const int V2TIM_GROUP_MEMBER_ROLE_ADMIN = 300;
  // ///群主
  // ///
  // static const int V2TIM_GROUP_MEMBER_ROLE_OWNER = 400;
  List<String> menuAdmin = ['QR', 'Share to Posts', 'Group Info']; //管理员
  List<String> menuUser = ['QR', 'Group Info']; //普通用户
  RxList<String> popMenus = RxList([]);
  List<String> popPrivateMenus = [];
  RxBool groupExists = false.obs;
}