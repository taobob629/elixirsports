// lib/config/ApiConfig.dart
import 'dart:io';
import '../config/app_config.dart'; // 假设你有本地存储工具类（用于获取token）
import 'package:elixir_esports/utils/storage_manager.dart';

/// 接口全局配置类
class ApiConfig {
  // ===================== 基础配置 =====================
  /// 接口基础域名（根据你的实际环境修改）
  /// 开发环境/测试环境/生产环境可通过环境变量切换
  static const String baseUrl = "http://146.56.192.175:8091"; // 替换为你的真实域名

  /// 默认超时时间（秒）
  static const int timeoutSeconds = 10;

  /// 接口版本号（如果需要）
  static const String apiVersion = "v1";

  // ===================== 请求头配置 =====================
  /// 默认请求头（所有接口通用）
  static Map<String, String> get defaultHeaders {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json",
      "User-Agent": "ElixirEsports/${apiVersion} (Android/iOS)",
      "Platform": Platform.isAndroid ? "android" : "ios",
    };

    // 自动添加登录Token（如果用户已登录）
    String? token = StorageManager.getToken();; // 从本地存储获取token
    if (token != null && token.isNotEmpty) {
      headers["X-Wanyoo-Token"] = token;
    }

    return headers;
  }

  // ===================== 接口路径常量（可选，便于维护） =====================
  /// 订单相关接口
  static const String orderDetail = "/app/order/detail";
  static const String createOrder = "/app/order/create";

  /// 优惠券相关接口
  static const String getCustomerCoupon = "/app/home/getCustomerCoupon";
  static const String useCoupon = "/app/home/useCoupon";

  /// 支付相关接口
  static const String balancePay = "/app/wallet/balancePay";
  static const String getPGWPaymentTokenAndUrl = "/app/wallet/getPGWPaymentTokenAndUrl";

  // ===================== 环境切换方法（可选） =====================
  /// 切换接口环境（开发/测试/生产）
  /// [env] 0:开发 1:测试 2:生产
  static void switchEnvironment(int env) {
    switch (env) {
      case 0:
      // 开发环境
        const String devBaseUrl = "https://dev-api.your-domain.com";
        // 注意：const 变量无法重新赋值，如需动态切换，可将 baseUrl 改为 static String 类型
        break;
      case 1:
      // 测试环境
        const String testBaseUrl = "https://test-api.your-domain.com";
        break;
      case 2:
      // 生产环境
        const String prodBaseUrl = "https://api.your-domain.com";
        break;
    }
  }
}