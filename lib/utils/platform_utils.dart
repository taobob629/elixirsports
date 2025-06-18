import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';

export 'dart:io';

/// 是否是生产环境
const bool inProduction = bool.fromEnvironment("dart.vm.product");

class PlatformUtils {
  static Future<PackageInfo> getAppPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNum() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
}
