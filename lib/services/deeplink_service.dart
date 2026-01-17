import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'singpass_service.dart';

/// 深度链接处理服务
class DeeplinkService {
  /// 监听深度链接的流控制器
  final StreamController<Uri> _deeplinkStreamController = StreamController<Uri>.broadcast();
  
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

    // 检查是否是 Singpass 回调链接
    if (uri.scheme == 'elixiresports' && uri.path == '/callback') {
      await _handleSingpassCallback(uri);
    }

    // 可以添加其他深度链接处理逻辑
  }

  /// 处理 Singpass 回调
  Future<void> _handleSingpassCallback(Uri uri) async {
    try {
      // 从链接中获取授权码
      final code = uri.queryParameters['code'];
      if (code == null) {
        throw Exception('Authorization code not found in Singpass callback');
      }

      print('Singpass callback received with code: $code');

      // 显示加载对话框
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // 调用 Singpass 服务处理回调
      final tokenResponse = await SingpassService.handleSingpassCallback(code);

      // 关闭加载对话框
      Get.back();

      if (tokenResponse != null) {
        // 跳转到主页或根据应用逻辑处理
        Get.offAllNamed('/main');
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
