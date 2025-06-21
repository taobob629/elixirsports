import 'package:elixir_esports/base/base_http.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../api/wy_http.dart';
import '../app.dart';
import '../utils/storage_manager.dart';

class AppConfig {
  static final Dio http = Dio();

  static final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  static OverlayEntry? overlayEntry;

  static String? name;

  static const String _devServer = 'http://146.56.192.175:8091/';
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

    bool? initDone = await _coreInstance.init(
        sdkAppID: 1600058781,
        loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
        language: LanguageEnum.en,
        listener: V2TimSDKListener(),
        onTUIKitCallbackListener: (TIMCallback callbackValue) {
          switch (callbackValue.type) {
            case TIMCallbackType.INFO:
              // Shows the recommend text for info callback directly
              flog("");
              break;
            case TIMCallbackType.API_ERROR:
              //Prints the API error to console, and shows the error message.
              flog("Error from TUIKit: ${callbackValue.errorMsg}, Code: ${callbackValue.errorCode}");
              if (callbackValue.errorCode == 10004 && callbackValue.errorMsg!.contains("not support @all")) {
                flog('');
              } else {
                flog('');
              }
              break;
            case TIMCallbackType.FLUTTER_ERROR:
            default:
              // prints the stack trace to console or shows the catch error
              if (callbackValue.catchError != null) {
                flog('');
              } else {
                flog(callbackValue.stackTrace);
              }
          }
        });
    if (initDone == true) {
      _coreInstance.setTheme(
        theme: TUITheme(
          textColor: Colors.white,
          chatBgColor: Colors.transparent,
          conversationItemTitleTextColor: toColor('1a1a1a'),
          conversationItemBorderColor: toColor('f5f5f5'),
          conversationItemBgColor: toColor('f5f5f5'),
          conversationItemPinedBgColor: toColor('f5f5f5'),
          chatMessageTongueBgColor: toColor('313033'),
          lightPrimaryColor: toColor('0A0A0A'),
          inputFillColor: toColor('000000'),
          chatMessageItemFromSelfBgColor: toColor('30302D'),
          chatMessageItemFromOthersBgColor: toColor('262731'),
        ),
      );
    }
  }

  static String getBaseServer() {
    String env = StorageManager.getEnv();
    if (env == "dev175") {
      return _devServer;
    }
    return _prodServer;
  }

  static Future<Widget> createApp() async {
    return App();
  }
}
