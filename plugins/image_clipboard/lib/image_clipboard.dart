import 'dart:async';

import 'package:flutter/services.dart';

class ImageClipboard {
  static const MethodChannel _channel = MethodChannel('image_clipboard');

  /// Copy image to clipboard
  ///
  /// [imagePath] The path to the image file
  /// Returns true if successful, false otherwise
  static Future<bool> copyImage(String imagePath) async {
    try {
      final bool result = await _channel.invokeMethod('copyImage', {
        'imagePath': imagePath,
      });
      return result;
    } on PlatformException catch (e) {
      print('Failed to copy image: ${e.message}');
      return false;
    }
  }
}
