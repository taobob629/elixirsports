import 'package:flutter/services.dart';

class SystemUtils {
  /// 隐藏软键盘
  static void hiddenSoftKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
