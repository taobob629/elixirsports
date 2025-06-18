import 'dart:convert';

import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/string_ext.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../../utils/utils.dart';
import '../../../getx_ctr/chat_ctr.dart';

class ChatPage extends StatelessWidget {
  final V2TimConversation selectedConversation;
  final String orderSn;
  final V2TimMessage? initFindingMsg;

  ChatPage({
    Key? key,
    required this.selectedConversation,
    this.orderSn = '',
    this.initFindingMsg,
  }) : super(key: key);

  String pwId = "";

  late ChatController controller;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ChatController>(tag: "ChatKey")) {
      controller = Get.put(
        ChatController(selectedConversation),
        tag: selectedConversation.conversationID,
      );
    }
    return TIMUIKitChat(
      appBarConfig: AppBar(
        elevation: 0,
      ),
      config: const TIMUIKitChatConfig(
        isUseDefaultEmoji: true,
      ),
      initFindingMsg: initFindingMsg,
      conversationID: selectedConversation.userID ?? '',
      // groupID or UserID
      conversationType: ConvType.c2c,
      // Conversation type
      conversationShowName: selectedConversation.showName ?? "",
      // Conversation display name
      userAvatarBuilder: (context, message) {
        if (message.customElem?.data != null &&
            message.customElem!.data! != "") {
          var json = jsonDecode(message.customElem!.data!);
          flog("userAvatarBuilder: $json");
          var data;

          if (json['type'] == "PostMessage") {
            if (json["message"] != null) {
              data = json['message'];
            }
            return ExtendedImage.network(
              data["avatar"] ?? "",
              width: 44.w,
              height: 44.w,
              shape: BoxShape.circle,
            );
          }
        }
        return ExtendedImage.network(
          message.faceUrl ?? "",
          width: 44.w,
          height: 44.w,
          shape: BoxShape.circle,
        );
      },
      messageItemBuilder: MessageItemBuilder(
          customMessageItemBuilder: (message, isShowJump, clearJump) {
        if (message.customElem?.data != null &&
            message.customElem!.data! != "") {
          var data = jsonDecode(message.customElem!.data!);
          var type = data['type'];
          if (data["message"] != null) {
            data = data['message'];
          }
          data['isself'] = message.isSelf;
          flog('data = $data');
          return GestureDetector(
            onTap: () {},
            child: _postMsgItem(
              type: type,
              data: data,
            ),
          );
        } else {
          return Text(
            "Unsupported message type, please update your app!",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white24,
            ),
          );
        }
      }),
      conversation:
          selectedConversation, // Callback for the clicking of the message sender profile photo. This callback can be used with `TIMUIKitProfile`.
    );
  }

  Widget _postMsgItem({var type, var data}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.r),
      decoration: BoxDecoration(
        color: toColor('313033'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data["nickname"],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                15.horizontalSpace,
                Text(
                  data["action"],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: toColor('FFB20E'),
                  ),
                ),
              ],
            ),
          ),
          7.verticalSpace,
          Text(
            (int.tryParse(data["addtime"].toString()) ?? 0).toDateStr,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF808388),
            ),
          ),
          8.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 13.h,
            ),
            decoration: BoxDecoration(
                color: toColor('262731'),
                borderRadius: BorderRadius.circular(10.r)),
            child: Text(
              data["content"],
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
          15.verticalSpace
        ],
      ),
    );
  }
}
