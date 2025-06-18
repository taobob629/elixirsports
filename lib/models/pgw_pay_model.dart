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
