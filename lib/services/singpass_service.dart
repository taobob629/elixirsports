import 'dart:convert';
import 'package:elixir_esports/api/wy_http.dart';
import 'package:elixir_esports/utils/storage_manager.dart';
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

  // 应用后台接口
  static const String authUrlEndpoint = '/web/api/singpass/login/auth-url';
  static const String callbackEndpoint = '/web/api/singpass/callback';
  static const String myinfoAuthUrlEndpoint =
      '/web/api/singpass/myinfo/auth-url';

  // 保存临时会话ID
  static String? _tempSessionId;

  /// 启动 Singpass 登录流程
  /// 返回认证 URL，用于在 In-App Browser 中加载
  static Future<String> login() async {
    final result = await getAuthUrl();
    return result;
  }

  /// 从后台获取 Singpass 认证 URL
  static Future<String> getAuthUrl() async {
    try {
      // 调用后台生成认证URL接口
      final response = await http.post(authUrlEndpoint);

      print("auth response:${response}");
      if (response.data != null) {
        String authUrl;
        String tempSessionId;

        // 检查响应格式：后台可能直接返回数据，或包装在'data'字段中
        if (response.data.containsKey('data')) {
          // 格式1：{"data": {"authUrl": "...", "tempSessionId": "..."}}
          authUrl = response.data['data']['authUrl'] as String;
          tempSessionId = response.data['data']['tempSessionId'] as String;
        } else {
          // 格式2：{"authUrl": "...", "tempSessionId": "..."}
          authUrl = response.data['authUrl'] as String;
          tempSessionId = response.data['tempSessionId'] as String;
        }

        _tempSessionId = tempSessionId;

        print('Using original auth URL from backend: $authUrl');

        // 直接使用后台提供的authUrl，后台会处理重定向
        return authUrl;
      } else {
        throw Exception('Failed to get auth URL from backend');
      }
    } catch (e) {
      print('Error getting Singpass auth URL: $e');
      rethrow;
    }
  }

  /// 处理 Singpass 回调
  static Future<Map<String, dynamic>?> handleSingpassCallback(
      String code, String state) async {
    try {
      if (_tempSessionId == null) {
        throw Exception('Temp session ID not found');
      }

      // 调用后台回调接口
      final response = await http.post(
        callbackEndpoint,
        data: {
          'code': code,
          'state': state,
          'tempSessionId': _tempSessionId,
        },
      );

      if (response.data != null) {
        // 存储应用内令牌
        await saveTokens(response.data);
        return response.data;
      } else {
        throw Exception('Failed to handle Singpass callback');
      }
    } catch (e) {
      print('Singpass callback handling error: $e');
      return null;
    } finally {
      // 清除临时会话ID
      _tempSessionId = null;
    }
  }

  /// 获取 MyInfo 授权 URL（新用户）
  static Future<String> getMyInfoAuthUrl() async {
    try {
      // 调用后台生成 MyInfo 认证URL接口
      final response = await http.post(myinfoAuthUrlEndpoint);

      if (response.data != null && response.data.containsKey('data')) {
        return response.data['data']['authUrl'] as String;
      } else {
        throw Exception('Failed to get MyInfo auth URL from backend');
      }
    } catch (e) {
      print('Error getting MyInfo auth URL: $e');
      rethrow;
    }
  }

  /// 保存应用内令牌
  static Future<void> saveTokens(Map<String, dynamic> tokens) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = tokens['access_token'] ?? '';

    // 使用现有的StorageManager保存token，与其他登录流程保持一致
    if (accessToken.isNotEmpty) {
      StorageManager.setToken(accessToken);
    }

    // 保存到SharedPreferences（SingPass特定的令牌存储）
    await prefs.setString('app_access_token', accessToken);
    await prefs.setString('app_refresh_token', tokens['refresh_token'] ?? '');
    await prefs.setString('app_id_token', tokens['id_token'] ?? '');

    // 保存令牌过期时间
    final expiresIn = tokens['expires_in'] as int? ?? 3600;
    final expiresAt =
        DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
    await prefs.setInt('app_token_expires_at', expiresAt);
  }

  /// 检查用户是否已登录
  static Future<bool> isLoggedIn() async {
    // 优先检查StorageManager中的token，与其他登录流程保持一致
    final storageToken = StorageManager.getToken();
    if (storageToken.isNotEmpty) {
      return true;
    }

    // 同时检查SingPass特定的令牌存储
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
    // 清除StorageManager中的token，与其他登录流程保持一致
    StorageManager.clear(StorageManager.kToken);

    // 清除SingPass特定的令牌存储
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
        '/web/api/singpass/refresh-token',
        data: {
          'refresh_token': refreshToken,
        },
      );

      if (response.data != null) {
        await saveTokens(response.data);
        return true;
      }

      return false;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }
}
