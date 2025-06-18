import 'package:elixir_esports/base/base_http.dart';
import 'package:elixir_esports/api/wy_http.dart';

import '../models/login_model.dart';
import '../models/privacy_model.dart';
import '../models/profile_model.dart';

class LoginApi {
  static Future<LoginModel> login(String username, String password) async {
    var response = await http.post('app/user/appLogin', data: {
      "username": username,
      "password": password,
    });

    return LoginModel.fromJson(response.data ?? {});
  }

  /// 个人中心数据
  static Future<ProfileModel> getProfile() async {
    var response = await http.get('app/user/profile',
        options: Options(extra: {
          "showLoading": false,
        }));

    return ProfileModel.fromJson(response.data);
  }

  /// 发送验证码
  static Future<String?> sendValidCode(String email) async {
    var response = await http.get(
      'app/user/sendValidCode',
      queryParameters: {"email": email},
    );

    return response.data["uid"];
  }

  /// 忘记密码
  static Future<void> forgetPassword(
      {required Map<String, dynamic> map}) async {
    var response = await http.post(
      'app/user/forgetPassword',
      data: map,
    );
  }

  /// 注册发送验证码
  static Future<String?> sendRegValidCode({
    required String email,
    required int type,
    required String country,
  }) async {
    var response = await http.get(
      'app/home/sendRegValidCode',
      queryParameters: {
        "email": email,
        "type": type,
        "country": country,
      },
    );

    return response.data == null ? null : response.data["uid"];
  }

  /// 注册验证验证码
  static Future<bool?> appRegValidCode({
    required String code,
    required String uid,
  }) async {
    var response = await http.get(
      'app/home/appRegValidCode',
      queryParameters: {
        "code": code,
        "uid": uid,
      },
    );

    return response.data["validated"];
  }

  /// 注册
  static Future<LoginModel> appRegister({
    required Map<String, dynamic> map,
  }) async {
    var response = await http.post(
      'app/home/appRegister',
      data: map,
    );

    return LoginModel.fromJson(response.data ?? {});
  }

  /// 隐私1：用户协议，2：隐私协议
  static Future<PrivacyModel> privacy(int type) async {
    var response = await http.get(
      'app/home/privacy',
      queryParameters: {"type": type},
    );

    return PrivacyModel.fromJson(response.data ?? {});
  }

  /// 获取货架
  static Future<List<String>> getCountry() async {
    var response = await http.get('app/home/getCountry');

    List<dynamic> listArr = response.data ?? [];
    List<String> list = listArr.cast<String>();

    return list;
  }
}
