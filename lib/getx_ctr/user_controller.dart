import 'dart:async';
import 'dart:convert';
import '../ui/pages/scanOrder/login_confirm_page.dart';
import '../ui/pages/scanOrder/pay_order_page.dart';
import 'package:elixir_esports/getx_ctr/wallet_ctr.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../../utils/toast_utils.dart';
import '../api/im_api.dart';
import '../api/login_api.dart';
import '../api/profile_api.dart';
import '../api/scan_api.dart';
import '../base/base_controller.dart';
import '../models/im_sig_model.dart';
import '../models/login_model.dart';
import '../models/profile_model.dart';
import '../models/scan_model.dart';
import '../ui/pages/login/login_page.dart';
import '../ui/pages/main/scan/scan_page.dart';
import '../ui/pages/main/scan/scan_to_unlock_page.dart';
import '../utils/message/chat_tool.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/icon_font.dart'; // 你的字体配置
import '../../utils/storage_manager.dart'; // 你的本地存储工具
import '../../ui/pages/scanOrder/scan_qr_page.dart'; // 扫码页面
import '../../ui/pages/scanOrder/login_confirm_page.dart'; // 登录确认页
import '../../ui/pages/scanOrder/pay_order_page.dart'; // 订单支付页
import '../../utils/order_api_utils.dart'; // 订单接口工具类
import '../../models/order_model.dart'; // 订单接口工具类

class UserController extends BasePageController {
  static UserController get find => Get.find();

  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  int nums = 1;

  DateTime lastLoginTime = DateTime.parse("1970-01-01 00:00:00");

  var imLoginDone = false.obs;

  var unreadMsgCount = 0.obs;
  final online = false.obs;

  var profileModel = ProfileModel(memberShip: []).obs;

  late Timer _timer;

  @override
  void onReady() async {
    super.onReady();
    flog('UserController onReady==');

    await login();
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      login();
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  Future<void> requestProfileData() async {
    profileModel.value = await LoginApi.getProfile();
  }

  Future<void> login() async {
    String username = StorageManager.getAccount();
    String password = StorageManager.getPassword();
    if (username.isEmpty || password.isEmpty) {
      return;
    }
    LoginModel model = await LoginApi.login(username, password);
    if (model.token != null) {
      StorageManager.setToken(model.token!);
      UserController.find.requestProfileData();
      imLogin();
    }
  }

  imLogin() async {
    flog('imLogin --${imLoginDone.value}');
    if (imLoginDone.value == false) {
      ImSigModel userSig = await ImApi.login();
      if (userSig.token.isEmpty) return;
      flog("~~~~~~~~~${userSig.token}~~~~~~~~~~~~~");
      await _coreInstance.login(userID: userSig.uid, userSig: userSig.token).then((value) async {
        flog("登录状态信息：${value.code}: ${value.desc}");
        if (value.code != 0) {
          showToast(value.desc);
        } else {
          imLoginDone.value = true;
        }
        //执行登录 IM 成功后调用。初始化push
        // initOfflinePush();
        // print("~~~~~~~~~im login done~~~~~~~~~~~~~");
        TencentImSDKPlugin.v2TIMManager.getConversationManager().addConversationListener(
                listener: V2TimConversationListener(onTotalUnreadMessageCountChanged: (count) {
              flog(count, 'onTotalUnreadMessageCountChanged');
              unreadMsgCount.value = count;
              FlutterAppBadger.isAppBadgeSupported().then((value) {
                flog(value, 'onTotalUnreadMessageCountChanged');
                if (unreadMsgCount.value == 0) {
                  FlutterAppBadger.removeBadge();
                } else {
                  FlutterAppBadger.updateBadgeCount(unreadMsgCount.value, title: 'New Message');
                }
              });
            }, onConversationChanged: (v) {
              flog(v.length, 'onConversationChanged');
            }, onNewConversation: (v) {
              flog(v.length, 'onNewConversation');
            }));
        TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(listener: V2TimAdvancedMsgListener(onRecvNewMessage: (V2TimMessage msg) {
          //播放提示音
          if (unreadMsgCount > 0) {
            unreadMsgCount.value -= 1;
            FlutterAppBadger.updateBadgeCount(unreadMsgCount.value);
            FlutterRingtonePlayer().playNotification();
          }
          _dealMsg(msg);
        }));

        unreadMsgCount.value = await ChatTool.getUnreadMsgCount();

        ///获取未读数量
        // var v2timValueCallback = await TencentImSDKPlugin.v2TIMManager.getConversationManager().getTotalUnreadMessageCount();
        // if (v2timValueCallback.code == 0) {
        //   flog(v2timValueCallback.data, 'getTotalUnreadMessageCount');
        //   unreadMsgCount.value = v2timValueCallback.data!;
        //   FlutterAppBadger.isAppBadgeSupported().then((value) {
        //     if (unreadMsgCount.value == 0) {
        //       FlutterAppBadger.removeBadge();
        //     } else {
        //       flog(value, 'getTotalUnreadMessageCount');
        //       FlutterAppBadger.updateBadgeCount(unreadMsgCount.value, title: 'New Message');
        //     }
        //   });
        // }
      });
    }
  }

  void _dealMsg(V2TimMessage msg) {
    if (msg.customElem == null || msg.customElem?.data == null || msg.customElem?.data == "") {
      return;
    }

    flog('收到的消息： ${msg.customElem!.data!}');
    Map<String, dynamic> map = json.decode(msg.customElem!.data!);

    switch (map["type"]) {
      case 'Riot_Notify':
        // 拳头登录成功的通知
        String str = Get.routing.current;
        if ('/WebPage' == str) {
          Get.back(result: true);
        }
        break;
      case 'TopUp_Credit':
        // 拳头订单的通知
        dismissLoading();
        showToast(map['desc']);
        TencentImSDKPlugin.v2TIMManager.getMessageManager().markC2CMessageAsRead(userID: msg.sender!);
        ChatTool.getUnreadMsgCount().then((value) {
          unreadMsgCount.value = value;
        });
        if (Get.isRegistered<WalletCtr>()) {
          WalletCtr.find.onRefresh();
        }
        print(msg.sender);
        break;
    }
  }

  void logout({Function? done}) async {
    imLoginDone.value = false;
    StorageManager.clear(StorageManager.kUser);
    StorageManager.clear(StorageManager.kPassword);
    StorageManager.clear(StorageManager.kLoginTime);
    await _coreInstance.logout();
    done?.call();
    StorageManager.clear(StorageManager.kToken);

    imLoginDone.value = false;
    unreadMsgCount.value = 0;
  }

  Future<void> appLogout() async {
    showLoading();
    await _coreInstance.logout();
    dismissLoading();
    logout(done: () {
      StorageManager.setPassword("");
      flog("password logout = ${StorageManager.getPassword()}");
      Get.offAll(() => LoginPage());
    });
  }

  Future<void> deleteUser() async {
    showLoading();
    dismissLoading();
    await ProfileApi.appDeleteUsers();
    logout(done: () {
      StorageManager.setPassword("");
      flog("password logout = ${StorageManager.getPassword()}");

      Get.offAll(() => LoginPage());
    });
  }

  @override
  void requestData() {}

  Future<void> scan() async {
    try {
      // 1. 打开扫码页面，等待返回结果
      final String? scanResult = await Get.to(const ScanQrPage());

      print("二维码数据:${scanResult}");
      // 处理用户取消扫码（返回null/空字符串）
      if (scanResult == null || scanResult.isEmpty) {
        return;
      }

      // 2. 核心分支：判断是否为订单二维码（scanOrderPage:xxxxxx）
      if (scanResult.startsWith('scanOrderPage:')) {
        // 提取订单号（去掉前缀并去空格）
        String orderId = scanResult.replaceAll('scanOrderPage:', '').trim();

        // 校验订单号是否为空
        if (orderId.isEmpty) {
          Get.snackbar(
            'Error'.tr,
            'Invalid order number, please scan a valid QR code'.tr,
            backgroundColor: const Color(0xFFFF760E).withOpacity(0.8),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(bottom: 20.h, left: 15.w, right: 15.w),
            duration: const Duration(seconds: 3),
          );
          return;
        }

        // 3. 显示加载弹窗
        Get.dialog(
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Color(0xFFFF760E)),
                  10.horizontalSpace,
                  Text(
                    'Loading'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false, // 禁止点击空白关闭
        );

        OrderResponse? orderResponse; // 订单响应数据
        try {
          // 4. 请求订单数据（增加10秒超时处理）
          orderResponse = await OrderApiUtils.getOrderByOrderId(orderId)
              .timeout(const Duration(seconds: 10), onTimeout: () {
            throw Exception('Request timeout, please try again later');
          });
        } catch (e) {
          // 请求异常：先关闭弹窗，再提示
          Get.back(); // 必须先关闭弹窗
          Get.snackbar(
            'Error'.tr,
            'Failed to get order data: ${e.toString()}'.tr,
            backgroundColor: const Color(0xFFFF760E).withOpacity(0.8),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(bottom: 20.h, left: 15.w, right: 15.w),
            duration: const Duration(seconds: 3),
          );
          return; // 终止后续逻辑
        } finally {
          // 最终保障：无论成功/失败，都关闭弹窗（防止漏关）
          if (Get.isDialogOpen == true) {
            Get.back();
          }
        }

        // 5. 弹窗已关闭，再处理页面跳转
        if (orderResponse != null && orderResponse.code == 200 && orderResponse.data != null) {
          if (orderResponse.data!.needLogin) {
            // 需要登录 → 跳转到登录确认页
            await Get.to(
              LoginConfirmPage(
                loginTips: orderResponse.data!.loginTips,
                orderData: orderResponse.data!,
              ),
            );
          } else {
            print("直接跳转到支付页");
            if (orderResponse.data!.openOrder){
              await Get.to(PayOrderPage(orderData: orderResponse.data!));
            }else {
              Get.snackbar(
                'Error'.tr,
                orderResponse?.msg ?? 'Order expired'.tr,
                backgroundColor: const Color(0xFFFF760E).withOpacity(0.8),
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.only(bottom: 20.h, left: 15.w, right: 15.w),
                duration: const Duration(seconds: 4),
              );
            }
            // 无需登录 → 直接跳转到支付页

          }
        } else {
          print("报错了，订单数据获取失败提示");
          // 订单数据无效：提示用户
          Get.snackbar(
            'Error'.tr,
            orderResponse?.msg ?? 'Failed to get order data'.tr,
            backgroundColor: const Color(0xFFFF760E).withOpacity(0.8),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(bottom: 20.h, left: 15.w, right: 15.w),
            duration: const Duration(seconds: 2),
          );
        }

      } else {
        // 非订单二维码：内层捕获异常，避免冒泡到外层
        try {
          _handleOriginalScanLogic(scanResult); // 补加await，确保异步完成
        } catch (innerE) {
          print('非订单二维码逻辑异常：$innerE');
          Get.snackbar(
            'Non-Order QR Code'.tr,
            'Invalid QR code: ${innerE.toString()}'.tr,
            backgroundColor: Colors.black.withOpacity(0.8),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(bottom: 20.h, left: 15.w, right: 15.w),
            duration: const Duration(seconds: 5),
          );
        }
      }
    } catch (e) {
      print('扫码流程全局异常：$e');
      // 全局异常：若有弹窗未关，先关闭
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.snackbar(
        'Error'.tr,
        'Scan failed: ${e.toString()}'.tr,
        backgroundColor: const Color(0xFFFF760E).withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(bottom: 20.h, left: 15.w, right: 15.w),
        duration: const Duration(seconds: 5),
      );
    }
  }
// 补全/修复原有扫码逻辑
  void _handleOriginalScanLogic(String scanResult) async {

    // final value = await Get.to(() => ScanPage());
    // flog('value $value');
    // if (value == null) {
    //   return;
    // }
    // String data = value.toString();
    ScanModel model = await ScanApi.scanInfo(data: scanResult);
    Get.to(() => ScanToUnlockPage(), arguments: model);
  }

  void jumpPhoneOrMap({String? phone, String? map}) async {
    if (phone != null) {
      Uri uri = Uri.parse('tel:$phone');

      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
      return;
    }

    Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$map');
    // Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
