import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Singpass v5 认证服务类
/// 注意：Singpass v5 不再需要 Client Secret
class SingpassService {
  // Singpass v5 配置
  static const String clientId =
      'XzyYqME7JJljlhBXxRDMtLcTI4VNhAu4'; // 替换为您的 Client ID
  static const String redirectUri = 'elixiresports://callback'; // 应用的回调 URI
  static const String authorizationEndpoint =
      'https://stg-id.singpass.gov.sg/auth';
  static const String tokenEndpoint = 'https://stg-id.singpass.gov.sg/token';
  static const String userInfoEndpoint =
      'https://stg-id.singpass.gov.sg/userinfo';

  // 应用后台接口
  static const String appBackendBaseUrl = 'https://your-app-backend.com/api';
  static const String appTokenExchangeEndpoint =
      '$appBackendBaseUrl/singpass/token-exchange';

  /// 启动 Singpass 登录流程
  /// 返回认证 URL，用于在 OAuthWebView 中加载
  static String login() {
    return buildAuthUrl();
  }

  /// 构建 Singpass 认证 URL
  static String buildAuthUrl() {
    final params = {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': 'openid myinfo.name myinfo.passport_number', // 根据需要添加其他 scope
      'state': _generateRandomState(),
      'nonce': _generateRandomNonce(),
      'code_challenge': _generateCodeChallenge(),
      'code_challenge_method': 'S256',
    };

    final uri =
        Uri.parse(authorizationEndpoint).replace(queryParameters: params);
    return uri.toString();
  }

  /// 生成随机 state
  static String _generateRandomState() {
    // 实际项目中应使用更安全的随机生成方法
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// 生成随机 nonce
  static String _generateRandomNonce() {
    // 实际项目中应使用更安全的随机生成方法
    return DateTime.now().millisecondsSinceEpoch.toString() + 'nonce';
  }

  /// 生成 code challenge
  static String _generateCodeChallenge() {
    // Singpass v5 使用 PKCE 流程，需要生成 code challenge
    // 实际项目中应使用正确的 PKCE 算法生成 code challenge
    // 这里简化处理，实际应实现完整的 PKCE 流程
    return 'sample-code-challenge';
  }

  /// 将授权码发送到应用后台进行令牌交换
  static Future<Map<String, dynamic>?> exchangeCodeWithBackend(
      String code) async {
    try {
      final response = await http.post(
        Uri.parse(appTokenExchangeEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'code': code,
          'redirect_uri': redirectUri,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(
            'Backend token exchange error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Backend token exchange network error: $e');
      return null;
    }
  }

  /// 保存应用内令牌
  static Future<void> saveTokens(Map<String, dynamic> tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_access_token', tokens['access_token'] ?? '');
    await prefs.setString('app_refresh_token', tokens['refresh_token'] ?? '');
    await prefs.setString('app_id_token', tokens['id_token'] ?? '');

    // 保存令牌过期时间
    final expiresIn = tokens['expires_in'] as int? ?? 3600;
    final expiresAt =
        DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
    await prefs.setInt('app_token_expires_at', expiresAt);
  }

  /// 处理 Singpass 回调
  static Future<Map<String, dynamic>?> handleSingpassCallback(
      String code) async {
    try {
      // 将授权码发送到应用后台进行令牌交换
      final tokenResponse = await exchangeCodeWithBackend(code);
      if (tokenResponse == null) {
        throw Exception('Failed to exchange code with backend');
      }

      // 存储应用内令牌
      await saveTokens(tokenResponse);

      return tokenResponse;
    } catch (e) {
      print('Singpass callback handling error: $e');
      return null;
    }
  }

  /// 检查用户是否已登录
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('app_access_token');
    final expiresAt = prefs.getInt('app_token_expires_at') ?? 0;

    // 检查令牌是否存在且未过期
    return accessToken != null &&
        accessToken.isNotEmpty &&
        DateTime.now().millisecondsSinceEpoch < expiresAt;
  }

  /// 用户登出
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_access_token');
    await prefs.remove('app_refresh_token');
    await prefs.remove('app_id_token');
    await prefs.remove('app_token_expires_at');
    await prefs.remove('app_user_info');
  }

  /// 获取当前登录用户信息
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString('app_user_info');
    if (userInfoJson == null) return null;
    return json.decode(userInfoJson);
  }

  /// 保存用户信息
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_user_info', json.encode(userInfo));
  }

  /// 获取应用访问令牌
  static Future<String?> getAccessToken() async {
    if (!await isLoggedIn()) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('app_access_token');
  }

  /// 刷新应用访问令牌
  static Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('app_refresh_token');

    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$appBackendBaseUrl/singpass/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final tokenResponse = json.decode(response.body);
        await saveTokens(tokenResponse);
        return true;
      }

      return false;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }
}
