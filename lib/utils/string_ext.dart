import 'package:date_format/date_format.dart';

extension StringExt on String {
  ///首字母大写
  String get toCapitalize {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }

  ///转换为正常时间
  String get toDateStr {
    try {
      // final now = DateTime.now();
      // final localTimeZoneOffset = now.timeZoneOffset; //取设备所在时区的偏移量
      return formatDate(
          DateTime.parse(this), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
    } catch (e) {
      return "";
    }
  }
}

extension IntExt on num {
  ///转换为正常时间
  String get toDateStr {
    try {
      return formatDate(
          DateTime.fromMillisecondsSinceEpoch(toInt() * 1000,
              isUtc: false),
          [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
    } catch (e) {
      return "";
    }
  }
}
