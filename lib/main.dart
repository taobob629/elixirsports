import 'package:catcher_2/core/catcher_2.dart';
import 'package:catcher_2/handlers/console_handler.dart';
import 'package:catcher_2/mode/dialog_report_mode.dart';
import 'package:catcher_2/model/catcher_2_options.dart';
import 'package:elixir_esports/utils/https_overrides.dart';
import 'package:elixir_esports/utils/platform_utils.dart';
import 'package:elixir_esports/utils/storage_manager.dart';
import 'package:elixir_esports/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_ume/core/plugin_manager.dart';
// import 'package:flutter_ume/core/ui/root_widget.dart';
// import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pgw_sdk/core/pgw_sdk_delegate.dart';
import 'package:pgw_sdk/enum/api_environment.dart';

import 'api/wy_http.dart';
import 'config/app_config.dart';

PackageInfo? packageInfo;

Future<void> getAppPackageInfo() async {
  packageInfo = await PlatformUtils.getAppPackageInfo();
  // deviceInfo = await PlatformUtils.getDeviceInfo();
  // flog(deviceInfo['manufacturer'], 'deviceInfo');
  flog(packageInfo!.appName, 'packageInfo');
  flog(packageInfo!.buildNumber, 'packageInfo');
  flog(packageInfo!.buildSignature, 'packageInfo');
  flog(packageInfo!.packageName, 'packageInfo');
  flog(packageInfo!.version, 'packageInfo');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = HttpsOverrides();

  await AppConfig.init("default");
  await getAppPackageInfo();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  var app = await AppConfig.createApp();

  ///图片缓存大小
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 20;
  String env = StorageManager.getEnv();

  Map<String, dynamic> pgwsdkParams = {'apiEnvironment': APIEnvironment.sandbox};

  await PGWSDK().initialize(pgwsdkParams, (error) {
    //Get error response and display error.
    flog("初始化支付错误：$pgwsdkParams, $error");
  }).whenComplete(() {
    if (env.contains("dev")) {
      // PluginManager.instance // 注册插件
      //     .register(DioInspector(dio: http));

      Catcher2Options debugOptions = Catcher2Options(
        DialogReportMode(),
        [ConsoleHandler()],
      );

      Catcher2Options releaseOptions = Catcher2Options(
        DialogReportMode(),
        [ConsoleHandler()],
      );

      // Catcher2(
      //   rootWidget: UMEWidget(enable: true, child: app),
      //   debugConfig: debugOptions,
      //   releaseConfig: releaseOptions,
      // );
      runApp(app);
    } else {
      runApp(app);
    }
  });

  // 实现沉浸式状态栏
  SystemUiOverlayStyle uiStyle = const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0x00000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: Color(0x00000000),
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(uiStyle);
}
