import 'package:elixir_esports/base/base_http.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/utils.dart';
import 'package:flutter/material.dart';

import '../api/wy_http.dart';
import '../app.dart';
import '../utils/storage_manager.dart';

class AppConfig {
  static final Dio http = Dio();

  static OverlayEntry? overlayEntry;

  static String? name;

  static const String _devServer = 'http://146.56.192.175:8091/';
  static const String _devServer2 = 'http://43.159.57.180:8091/';

  static const String _prodServer = 'http://www.elixiresports.com:8091/';

  static const isProd = bool.fromEnvironment('dart.vm.product');

  static const channel = String.fromEnvironment("channel");

  static const String ACTION_WB = 'wb';
  static const String ACTION_PW = 'pw';
  static const String ACTION_DEFAULT = 'default';

  static Future<void> init(String name, {var action = ACTION_DEFAULT}) async {
    AppConfig.name = name;
    await StorageManager.init();

    if (!StorageManager.haveEnv()) {
      StorageManager.setEnv(default_server);
    }
  }

  static String getBaseServer() {
    String env = StorageManager.getEnv();
    if (env == "dev175") {
      return _devServer;
    }
    if (env == "dev180") {
      return _devServer2;
    }
    return _prodServer;
  }

  static Future<Widget> createApp() async {
    return App();
  }
}
