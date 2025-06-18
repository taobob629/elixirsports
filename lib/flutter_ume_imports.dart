import 'package:flutter/material.dart';
// import 'package:flutter_ume/core/plugin_manager.dart';
// import 'package:flutter_ume/core/ui/root_widget.dart';
// import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:catcher_2/core/catcher_2.dart';
import 'package:catcher_2/handlers/console_handler.dart';
import 'package:catcher_2/mode/dialog_report_mode.dart';
import 'package:catcher_2/model/catcher_2_options.dart';

import 'api/wy_http.dart';

void initializeFlutterUme(Widget app) {
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
}
