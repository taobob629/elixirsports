import 'package:dio/dio.dart';
import 'package:elixir_esports/api/wy_http.dart';
import 'package:elixir_esports/models/ad_model.dart';
import 'package:elixir_esports/utils/platform_utils.dart';

import '../models/version_model.dart';

class ProfileApi {
  static Future<String> updateAvatar({
    required String filePath,
    Function(int, int)? sendCallback,
  }) async {
    var name = filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
    FormData formData = FormData.fromMap({
      //这里写其他需要传递的参数
      "file": await MultipartFile.fromFile(filePath, filename: name)
    });
    var response = await http.post('app/user/upload', data: formData, onSendProgress: sendCallback);

    return response.data['url'];
  }

  static Future<void> updateUsername({
    required String username,
  }) async {
    var response = await http.post(
      'app/user/updateProfile',
      data: {"name": username},
    );
  }

  static Future<void> changePassword({
    required String oldPwd,
    required String password,
  }) async {
    var response = await http.post(
      'app/user/changePassword',
      data: {
        "oldPwd": oldPwd,
        "password": password,
      },
    );
  }

  static Future<VersionModel> checkVersion() async {
    String platform = Platform.operatingSystem;
    String version = await PlatformUtils.getAppVersion();
    var response = await http.get('app/home/checkVersion', queryParameters: ({"version": version, "platform": platform}));
    return VersionModel.fromJson(response.data);
  }

  static Future<void> appDeleteUsers() async {
    // String platform = Platform.operatingSystem;
    String version = await PlatformUtils.getAppVersion();
    var response = await http.get('app/user/appDeleteUser', queryParameters: ({"version": "", "platform": ""}));
  }

  static Future<AdModel> checkAdPromote() async {
    var response = await http.get('app/home/checkAdPromote');
    return AdModel.fromJson(response.data ?? {});
  }
  static Future<void> clickPromote(AdModel model) async {
    // http.get('app/home/clickPromote?type='+model.type+"&id="+model.id);
    http.get('app/home/clickPromote', queryParameters: ({"type": model.type, "id": model.id}));
  }
}
