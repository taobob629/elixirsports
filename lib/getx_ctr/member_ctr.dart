import 'dart:convert';

import 'package:elixir_esports/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets_utils.dart';
import '../ui/dialog/top_up_confirm_dialog.dart';
import '../utils/color_utils.dart';
import '../utils/toast_utils.dart';
import 'user_controller.dart';
import '../models/profile_model.dart';

class MemberCtr extends BasePageController {
  static MemberCtr get find => Get.find();

  var currentIndex = 0.obs;

  @override
  void requestData() {
    currentIndex.value = Get.arguments;
  }

  String showNote() {
    switch (currentIndex.value) {
      case 0:
        return UserController.find.profileModel.value.memberShip[0].note ?? '';
      case 1:
        return UserController.find.profileModel.value.memberShip[1].note ?? '';
      default:
        return UserController.find.profileModel.value.memberShip[2].note ?? '';
    }
  }

  List<ContentModel> jsonToList() {
    List<dynamic> jsonList;
    switch (currentIndex.value) {
      case 0:
        jsonList = json.decode(UserController.find.profileModel.value.memberShip[0].content ?? '');
        break;
      case 1:
        jsonList = json.decode(UserController.find.profileModel.value.memberShip[1].content ?? '');
        break;
      default:
        jsonList = json.decode(UserController.find.profileModel.value.memberShip[2].content ?? '');
        break;
    }

    List<ContentModel> optionsList = jsonList.map((item) => ContentModel.fromJson(item)).toList();
    return optionsList;
  }

  Color getMemberShipNameTextColor(int index) {
    switch (UserController.find.profileModel.value.memberShip[index].level) {
      case 5:
        return toColor('#B59562');
      case 10:
        return toColor('#808080');
      default:
        return toColor('#6982B8');
    }
  }

  Color getMemberShipDescTextColor(int index) {
    switch (UserController.find.profileModel.value.memberShip[index].level) {
      case 5:
        return toColor('#C49342');
      case 10:
        return toColor('#5D5D5D');
      default:
        return toColor('#456CBF');
    }
  }

  Color getMemberShipTextColor(int index) {
    switch (UserController.find.profileModel.value.memberShip[index].level) {
      case 5:
        return toColor('#CAB18A');
      case 10:
        return toColor('#B6B6B6');
      default:
        return toColor('#95A7CE');
    }
  }

  String getMemberShipImg(int index) {
    switch (UserController.find.profileModel.value.memberShip[index].level) {
      case 5:
        return AssetsUtils.member_pic_gold;
      case 10:
        return AssetsUtils.member_pic_platinum;
      default:
        return AssetsUtils.member_pic_diamond;
    }
  }

  void payment() async {
    if (UserController.find.profileModel.value.topup == true) {
      await showCustom(
        TopUpConfirmDialog(
          money: int.parse(UserController.find.profileModel.value.memberShip[currentIndex.value].price ?? "0"),
          type: currentIndex.value == 0
              ? 10
              : currentIndex.value == 1
                  ? 15
                  : 5,
        ),
        alignment: Alignment.bottomCenter,
      );
      UserController.find.requestProfileData();
    }
  }
}
