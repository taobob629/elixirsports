class PgwPayModel {
  String paymentToken;
  String webPaymentUrl;
  String invoiceNo;

  PgwPayModel({
    required this.paymentToken,
    required this.webPaymentUrl,
    required this.invoiceNo,
  });

  factory PgwPayModel.fromJson(Map<String, dynamic> json) => PgwPayModel(
    paymentToken: json["paymentToken"] ?? "",
    webPaymentUrl: json["webPaymentUrl"] ?? "",
    invoiceNo: json["invoiceNo"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "paymentToken": paymentToken,
    "webPaymentUrl": webPaymentUrl,
    "invoiceNo": invoiceNo,
  };
}

class BalancePayResult {
  final String msg;
  final bool  state;
  int? orderId;

  BalancePayResult({
    required this.msg,
    required this.state,
    required this.orderId,

  });

  factory BalancePayResult.fromJson(Map<String, dynamic> json) => BalancePayResult(
    msg: json["msg"] ?? "",
    orderId: json["orderId"],
    state: json["state"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "state": state,
    "orderId": orderId,

  };
}

