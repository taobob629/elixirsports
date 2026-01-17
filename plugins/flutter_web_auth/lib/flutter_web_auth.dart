import 'dart:async';
import 'package:flutter/services.dart';

/// The FlutterWebAuth class provides a way to authenticate a user with a web service.
class FlutterWebAuth {
  static const MethodChannel _channel = MethodChannel('flutter_web_auth');

  /// Authenticates a user with a web service.
  /// 
  /// The [url] specifies the URL of the authentication web page.
  /// The [callbackUrlScheme] specifies the scheme of the callback URL.
  /// The [preferEphemeral] specifies whether to use an ephemeral browser session.
  /// 
  /// Returns a [Future] that completes with the callback URL when the user has successfully authenticated.
  static Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
    bool preferEphemeral = false,
  }) async {
    final Map<String, dynamic> args = {
      'url': url,
      'callbackUrlScheme': callbackUrlScheme,
      'preferEphemeral': preferEphemeral,
    };
    
    return await _channel.invokeMethod<String>('authenticate', args) as String;
  }

  /// Cleans up any dangling calls that might be left over from previous authentication attempts.
  static Future<void> cleanUpDanglingCalls() async {
    await _channel.invokeMethod('cleanUpDanglingCalls');
  }
}