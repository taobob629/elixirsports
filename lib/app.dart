import 'package:catcher_2/core/catcher_2.dart';
import 'package:elixir_esports/ui/pages/main_page.dart';
import 'package:elixir_esports/ui/widget/custom_error_widget.dart';
import 'package:elixir_esports/ui/widget/custom_loading_widget.dart';
import 'package:elixir_esports/ui/widget/custom_success_widget.dart';
import 'package:elixir_esports/ui/widget/custom_toast_widget.dart';
import 'package:elixir_esports/ui/widget/custom_warn_widget.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'config/controller/bindings.dart';
import 'config/icon_font.dart';
import 'getx_ctr/user_controller.dart';
import 'lang/translations.dart';

class App extends StatelessWidget {
  // final cartController = Get.put(CartController(), permanent: true);

  final userController = Get.put(UserController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //只能纵向
      DeviceOrientation.portraitDown, //只能纵向
    ]);
    final ThemeData theme = ThemeData(fontFamily: FONT_LIGHT);

    return RefreshConfiguration(
        headerBuilder: () => WaterDropHeader(
              waterDropColor: toColor('C5C3C6'),
            ),
        footerBuilder: () => const ClassicFooter(
              noDataText: "",
            ),
        enableLoadingWhenFailed: true,
        hideFooterWhenNotFull: !true,
        enableBallisticLoad: true,
        child: ScreenUtilInit(
          // designSize: const Size(360, 690),
          designSize: const Size(375, 812),

          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              initialBinding: InitialBindings(),
              debugShowCheckedModeBanner: false,
              navigatorKey: Catcher2.navigatorKey,
              theme: theme.copyWith(
                  textTheme: const TextTheme(),
                  appBarTheme: AppBarTheme(
                    backgroundColor: toColor('F5F5F5'),
                    elevation: 0,
                    centerTitle: true,
                    titleTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  // primaryColor: AppColor.accent,
                  unselectedWidgetColor: Colors.white,
                  scaffoldBackgroundColor: toColor('F5F5F5'),
                  primaryIconTheme: IconThemeData(color: toColor('C5C3C6')),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: toColor('F5F5F5'),
                      foregroundColor: toColor('C5C3C6'),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FONT_MEDIUM,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  colorScheme: theme.colorScheme.copyWith(
                    primary: toColor('F5F5F5'),
                    secondary: toColor('e33e45'),
                    onSecondary: toColor('e33e45'),
                  )),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('zh', 'CN'),
              ],
              // locale: DevicePreview.locale(context),
              translations: Messages(),
              //跟随系统语言
              fallbackLocale: const Locale('en', 'US'),
              home: MainPage(),
              navigatorObservers: [FlutterSmartDialog.observer],
              builder: FlutterSmartDialog.init(
                loadingBuilder: (String msg) => CustomLoadingWidget(
                  color: Colors.white,
                  size: 40.sp,
                ),
                toastBuilder: (String msg) => CustomToastWidget(msg: msg),
                notifyStyle: FlutterSmartNotifyStyle(
                  successBuilder: (String msg) => CustomSuccessWidget(msg),
                  warningBuilder: (String msg) => CustomWarnWidget(msg),
                  errorBuilder: (String msg) => CustomErrorWidget(msg),
                ),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                ),
              ),
            );
          },
        ));
  }
}
