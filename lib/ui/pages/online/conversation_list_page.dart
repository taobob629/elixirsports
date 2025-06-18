import 'dart:convert';

import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/base/base_scaffold.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../utils/message/chat_tool.dart';
import 'chat_page.dart';

const int type_single_chat = 0;
const int type_group = 1;

/// 客服列表
class ConversationListPage extends StatelessWidget {
  int type;
  final Function(int count)? unreadCountChange;

  ConversationListPage(
      {Key? key, this.type = type_single_chat, this.unreadCountChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Messages".tr,
      appBarBackgroundColor: toColor('f5f5f5'),
      backgroundColor: toColor('f5f5f5'),
      body: TIMUIKitConversation(
        isShowDraft: false,
        conversationCollector: (conversationItem) {
          /// 专用自定义消息渠道，不显示
          return ChatTool.converFilter(
              conversationItem?.userID, conversationItem?.groupID, type);
        },
        lastMessageBuilder: (lastMsg, groupAtInfoList) {
          if (lastMsg?.customElem?.data != null) {
            var data;
            try {
              data = jsonDecode(lastMsg!.customElem!.data!);
            } catch (e) {
              return Text(
                "Unknown",
                style: TextStyle(
                  color: toColor('B2B9C9'),
                  fontSize: 12.sp,
                ),
              );
            }
            return Text(
              data["desc"] ?? "",
              style: TextStyle(
                color: toColor('B2B9C9'),
                fontSize: 12.sp,
              ),
            );
          }
          return Text(
            lastMsg?.textElem?.text ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: toColor('B2B9C9'),
              fontSize: 12.sp,
            ),
          );
        },
        onTapItem: (selectedConv) {
          Get.to(() => ChatPage(
                selectedConversation: selectedConv,
              ))?.then((res) async {
            if (res != null) {
              await TIMUIKitCore.getSDKInstance()
                  .getConversationManager()
                  .deleteConversation(
                      conversationID: selectedConv.conversationID);
              TUIConversationViewModel model =
                  serviceLocator<TUIConversationViewModel>();
              model.refresh();
            }
          });
        },
        emptyBuilder: () => Padding(
          padding: EdgeInsets.only(top: 140.h),
          child: Image.asset(AssetsUtils.empty),
        ),
      ),
    );
  }
}
