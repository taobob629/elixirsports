import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:elixir_esports/utils/storage_manager.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' as getX;

import '../config/app_config.dart';
import '../ui/pages/login/login_page.dart';
import '../ui/widget/show_error_widget.dart';
import '../utils/platform_utils.dart';
import '../utils/toast_utils.dart';
import '../utils/utils.dart';
import '../base/base_http.dart';

///是否正在登录
bool isSigningIn = false;

Dio http = Dio(
  BaseOptions(
    baseUrl: AppConfig.getBaseServer(),
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ),
);

// class Http extends BaseHttp {
//   @override
//   void init() async {
//     options.baseUrl = AppConfig.getBaseServer();
//     // options.baseUrl = "http://139.186.149.117:8091/";
//     interceptors
//       ..add(ApiInterceptor())
//       ..add(HeaderInterceptor());
//   }
// }

class HeaderInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (StorageManager.getToken().isNotEmpty) {
      options.headers['X-Wanyoo-Token'] = StorageManager.getToken();
    }
    options.headers['platform'] = Platform.operatingSystem;
    options.headers['language'] = language();
    // options.headers['phoneModel'] =Platform.isIOS? deviceInfo['name']:  '${deviceInfo['manufacturer']}-${deviceInfo['brand']}';
    // options.headers['longitude'] = LocationService().position?.longitude ?? 0;
    // options.headers['latitude'] = LocationService().position?.latitude ?? 0;
    // log(jsonEncode(options.headers), name: 'options.headers');
    handler.next(options);
  }
}

//语言 0中文
String language() {
  Locale? locale = getX.Get.locale;
  var code = locale?.countryCode;
  flog("language = $code");
  switch (code) {
    case 'CN':
      return 'CN';
    default:
      return "EN";
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra["showLoading"] == null) {
      showLoading();
    }
    // log(
    //   'api-request:${options.baseUrl}${options.path}' +
    //       ' queryParameters: ${options.queryParameters} data :${options.data} ',
    //   name: "WY_API",
    // );
    // print('---api-request--->data--->${options.data}');
    handler.next(options);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.extra["showLoading"] == null) {
      dismissLoading(status: SmartStatus.loading);
    }
    String requestPath = response.requestOptions.path;
    // flog(' requestPath:$requestPath onResponse api-response ${response}');
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      response.statusMessage = respData.msg;
      return handler.next(response);
    } else {
      if (respData.code == 401) {
        //throw const UnAuthorizedException(); // 需要登录
        getX.Get.to(() => LoginPage());
      } else {
        if (respData.msg.isEmpty) {
          showErrorWidget("Server Failure");
        } else {
          showInfo(respData.msg);
        }

        // response.data = respData.data;
        // response.statusMessage = respData.msg;
        // response.statusCode = respData.code;
        return handler.next(response);
      }
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    // log(' onError: ${err.message}');
    dismissLoading(status: SmartStatus.loading);
    showToast("Networking Failure");
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    msg = json['msg'] ?? "";
    data = json['data'];
    if (data == null && json["rows"] != null) {
      data = json;
    }
  }
}
