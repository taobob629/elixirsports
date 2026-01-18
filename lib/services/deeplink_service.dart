import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'singpass_service.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import '../utils/storage_manager.dart';

// 导入页面组件
import '../ui/pages/login/login_page.dart';
import '../ui/pages/main_page.dart';

// 导入对话框组件
import '../ui/dialog/register_success_dialog.dart';

/// 深度链接处理服务
class DeeplinkService {
  /// 监听深度链接的流控制器
  final StreamController<Uri> _deeplinkStreamController =
      StreamController<Uri>.broadcast();

  /// AppLinks实例
  final AppLinks _appLinks = AppLinks();

  /// 获取深度链接流
  Stream<Uri> get deeplinkStream => _deeplinkStreamController.stream;

  /// 初始化深度链接监听
  Future<void> init() async {
    // 处理应用启动时的初始链接
    await _handleInitialUri();

    // 监听应用运行时的深度链接
    _listenToUriChanges();
  }

  /// 处理应用启动时的初始链接
  Future<void> _handleInitialUri() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      if (uri != null) {
        _handleDeeplink(uri);
      }
    } catch (e) {
      print('Error handling initial uri: $e');
    }
  }

  /// 监听应用运行时的深度链接变化
  void _listenToUriChanges() {
    // 监听深度链接流
    _appLinks.uriLinkStream.listen(
      (uri) {
        if (uri != null) {
          _handleDeeplink(uri);
        }
      },
      onError: (Object err) {
        print('Error listening to uri changes: $err');
      },
    );
  }

  /// 处理深度链接
  Future<void> _handleDeeplink(Uri uri) async {
    print('Received deeplink: $uri');
    print('Received deeplink: ${uri.scheme}');

    print('Received deeplink: ${uri.path}');

    // 检查是否是 Singpass 回调链接
    if (uri.scheme == 'elixiresports') {
      await _handleSingpassCallback(uri);
    }

    // 可以添加其他深度链接处理逻辑
  }

  /// 处理 Singpass 回调
  Future<void> _handleSingpassCallback(Uri uri) async {
    try {
      // 从链接中获取参数
      final code = uri.queryParameters['code'];
      final state = uri.queryParameters['state'];
      final tempSessionId = uri.queryParameters['tempSessionId'];
      final token = uri.queryParameters['token'];
      final appState = uri.queryParameters['appState'];

      print(
          'Singpass callback received with appState: $appState, code: $code, state: $state');

      // 显示加载对话框
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // 根据appState参数处理不同情况
      if (appState == 'loginSuccess') {
        // 关闭加载对话框
        Get.back();

        // 保存token到StorageManager
        if (token != null && token.isNotEmpty) {
          StorageManager.setToken(token);
        }

        // 跳转到主页
        Get.offAll(() => MainPage());

        // 提示登录成功
        Get.snackbar('Success'.tr, 'Login successfully'.tr,
            backgroundColor: Colors.green, colorText: Colors.white);
      } else if (appState == 'loginFailed') {
        // 关闭加载对话框
        Get.back();

        // 跳回登录页面
        Get.offAll(() => LoginPage());

        // 提示登录失败
        Get.snackbar('Failed'.tr, 'Login failed'.tr,
            backgroundColor: Colors.red[700]!, colorText: Colors.white);
      } else if (appState == 'needRegister') {
        // 关闭加载对话框
        Get.back();

        // 根据新需求：后台会直接redirect到MyInfo登录界面，不再需要我们处理
        // 显示提示信息，告诉用户正在处理
        Get.snackbar(
            'Redirecting'.tr, 'Redirecting to MyInfo registration...'.tr,
            backgroundColor: Colors.blue[700]!, colorText: Colors.white);

        // 跳回登录页面，等待用户完成MyInfo流程后返回
        Get.offAll(() => LoginPage());
      } else if (appState == 'newUser') {
        // 关闭加载对话框
        Get.back();

        // 保存token到StorageManager
        if (token != null && token.isNotEmpty) {
          StorageManager.setToken(token);
        }

        // 跳转到主页
        Get.offAll(() => MainPage());

        // 显示注册成功对话框
        await showCustom(RegisterSuccessDialog());

      } else {
        // 传统流程：没有appState参数时的处理
        if (code == null || state == null) {
          throw Exception(
              'Authorization code or state not found in Singpass callback');
        }

        // 调用 Singpass 服务处理回调
        final tokenResponse =
            await SingpassService.handleSingpassCallback(code, state);

        // 关闭加载对话框
        Get.back();

        if (tokenResponse != null) {
          // 跳转到主页或根据应用逻辑处理
          Get.offAll(() => MainPage());
        } else {
          // 处理令牌交换失败
          Get.dialog(
            AlertDialog(
              title: const Text('Login Failed'),
              content: const Text(
                  'Failed to exchange Singpass code for tokens. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // 关闭加载对话框（如果打开）
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // 显示错误信息
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  /// 关闭流控制器
  void dispose() {
    _deeplinkStreamController.close();
  }
}

/// 深度链接服务实例
final deeplinkService = DeeplinkService();
