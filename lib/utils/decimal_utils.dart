import 'package:decimal/decimal.dart';

extension WidgetPaddingX on String {
  String add(String params) =>
      (Decimal.parse(this) + Decimal.parse(params)).toString();

  String minus(String params) =>
      (Decimal.parse(this) - Decimal.parse(params)).toString();

  String mul(String params) =>
      (Decimal.parse(this) * Decimal.parse(params)).toString();

  String division(String params) =>
      (Decimal.parse(this) / Decimal.parse(params)).toString();
}
