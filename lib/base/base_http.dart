import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';

import '../utils/platform_utils.dart';

export 'package:dio/dio.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

abstract class BaseHttp extends DioForNative {
  BaseHttp() {
    /// 初始化 加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    interceptors.add(HeaderInterceptor());

    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port){
        return true;
      };
      // client.findProxy = (uri){
      //   return AppConfig.isProd ? 'DIRECT':'PROXY 192.168.0.164:8888';
      // };
    };

    init();
  }

  void init();
}

/// 添加常用Header
class HeaderInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.connectTimeout = 1000 * 30;
    options.receiveTimeout = 1000 * 30;

    var appVersion = await PlatformUtils.getAppVersion();
    options.headers['appVersion'] = appVersion;
    options.headers['platform'] = Platform.operatingSystem;
    handler.next(options);
  }
}

/// 子类需要重写
abstract class BaseResponseData {
  late int code;
  late String msg;
  dynamic data;

  bool get success;

  BaseResponseData();


  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $msg, data: $data}';
  }
}


/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  String? message;

  NotSuccessException.fromRespData(BaseResponseData respData) {
    message = respData.msg;
  }

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}

