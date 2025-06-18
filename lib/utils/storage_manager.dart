import 'dart:developer';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lang/translations.dart';
import '../main.dart';

// const String default_server='dev184';//上线时候要改成prod
const String default_server='prod';//上线时候要改成prod
class StorageManager {
  /// app全局配置
  static late SharedPreferences sharedPreferences;

  /// 临时目录
  static Directory? temporaryDirectory;

  static const String kUser = 'kUser';
  static const String kToken = 'kToken';
  static const String kAccount = 'kAccount';
  static const String kPassword = 'kPassword';
  static const String kLoginTime = 'kLoginTime';
  static const String kCart = 'kCart';
  static const String kCredit = 'kCredit';
  static const String kPushToken = 'kPushToken';
  static const String kEnv = 'kEnv';
  static const String kOnline = 'kOnline'; //是否通过审核在线版
  static const String kPayPasswordCheckTime = 'kPayPasswordCheckTime';
  static const String kLocal = 'kLocal';
  static const String kFirstUse = 'firstUse'; //是否首次安装
  static const String kCountDown = 'kCountDown';
  static const String kCountDown2 = 'kCountDown2';
  static const String kFirstMatchTime = 'kFirstMatchTime';

  /// 必备数据的初始化操作
  ///
  /// 由于是同步操作会导致阻塞,所以应尽量减少存储容量
  static init() async {
    temporaryDirectory = await getTemporaryDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static String getToken() {
    String? value = sharedPreferences.getString(kToken);
    if (value == null) {
      return "";
    }
    return value;
  }

  static void setToken(String value) {
    sharedPreferences.setString(kToken, value);
  }

  static DateTime getPayPasswordCheckTime() {
    String? value = sharedPreferences.getString(kPayPasswordCheckTime);
    if (value == null) {
      return DateTime.parse("1970-01-01 00:00:00");
    }
    return DateTime.fromMillisecondsSinceEpoch(int.parse(value));
  }

  static void setPayPasswordCheckTime(DateTime value) {
    sharedPreferences.setString(kPayPasswordCheckTime, value.millisecondsSinceEpoch.toString());
  }

  static String getPushToken() {
    String? value = sharedPreferences.getString(kPushToken);
    if (value == null) {
      return "";
    }
    return value;
  }

  static void setPushToken(String? value) {
    log("PushToken::$value", name: "WY");
    sharedPreferences.setString(kPushToken, value == null ? "" : value);
  }

  static String getAccount() {
    String? value = sharedPreferences.getString(kAccount);
    if (value == null) {
      return "";
    }
    return value;
  }

  static void setAccount(String value) {
    sharedPreferences.setString(kAccount, value);
  }

  static String getPassword() {
    String? value = sharedPreferences.getString(kPassword);
    if (value == null) {
      return "";
    }
    return value;
  }

  static void setPassword(String value) {
    sharedPreferences.setString(kPassword, value);
  }

  static int getLoginTime() {
    int? value = sharedPreferences.getInt(kLoginTime);
    if (value == null) {
      return 0;
    }
    return value;
  }

  static void setLoginTime(int value) {
    sharedPreferences.setInt(kLoginTime, value);
  }

  static String getCart() {
    String? value = sharedPreferences.getString(kCart);
    if (value == null) {
      return "";
    }
    return value;
  }

  static void setCart(String value) {
    sharedPreferences.setString(kCart, value);
  }

  static bool getOnline() {
    if (Platform.isAndroid) {
      return true;
    }
    return sharedPreferences.getBool(kOnline) ?? false;
  }

  static Future<void> setOnline(bool value) async {
    await sharedPreferences.setBool(kOnline, value);
  }

  static String getEnv() {
    String? value = sharedPreferences.getString(kEnv);
    if (value == null) {
      return default_server;
    }
    if (packageInfo!.version == '0.2.10') return default_server;
    return value;
  }

  static bool haveEnv() {
    String? value = sharedPreferences.getString(kEnv);
    if (value == null || value.isEmpty) {
      return false;
    }
    return true;
  }

  static void setEnv(String value) {
    sharedPreferences.setString(kEnv, value);
  }

  static void clear(String key) {
    sharedPreferences.remove(key);
  }

  static void setLocal(var languageCode) {
    sharedPreferences.setString(kLocal, languageCode);
  }

  static Locale? getLocal() {
    String? local = sharedPreferences.getString(kLocal);
    if (local == null) return Get.deviceLocale; //没有设置，跟随系统
    if (local == CHINA.languageCode) {
      // Get.updateLocale(CHINA);
      return CHINA;
    } else {
      //Get.updateLocale(ENGLISH);
      return ENGLISH;
    }
  }

  static bool getFirstUse() {
    bool? value = sharedPreferences.getBool(kFirstUse);
    return value ?? true;
  }

  static void setFirstUse(bool value) {
    sharedPreferences.setBool(kFirstUse, value);
  }

  static String? getCountDown() {
    String? value = sharedPreferences.getString(kCountDown);
    return value;
  }

  static void setCountDown(String value) {
    sharedPreferences.setString(kCountDown, value);
  }

  static String? getCountDown2() {
    String? value = sharedPreferences.getString(kCountDown2);
    return value;
  }

  static void setCountDown2(String value) {
    sharedPreferences.setString(kCountDown2, value);
  }

  static int? getValueByKey(String key) {
    int? value = sharedPreferences.getInt(key);
    return value;
  }

  static void setValue(String key, int value) {
    sharedPreferences.setInt(key, value);
  }

  static void setString(String key, String value) {
    sharedPreferences.setString(key, value);
  }

  static String? getString(String key) {
    String? value = sharedPreferences.getString(key);
    return value;
  }

  static bool? getBoolByKey(String key) {
    bool? value = sharedPreferences.getBool(key);
    return value;
  }

  static void setBoolValue(String key, bool value) {
    sharedPreferences.setBool(key, value);
  }
}
