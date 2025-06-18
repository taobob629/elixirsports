class BankCardModel {
  int? id;
  int? memberId;
  int? type;
  int? payState;
  String? email;
  String? payName;
  String? securityCode;
  String? expiryYear;
  String? expiryMonth;
  String? cardNo;
  String? notes;

  BankCardModel({
    this.id,
    this.memberId,
    this.type,
    this.payState,
    this.email,
    this.payName,
    this.securityCode,
    this.expiryYear,
    this.expiryMonth,
    this.cardNo,
    this.notes,
  });

  factory BankCardModel.fromJson(Map<String, dynamic> json) => BankCardModel(
    id: json["id"],
    memberId: json["memberId"],
    type: json["type"],
    payState: json["payState"],
    email: json["email"],
    payName: json["payName"],
    securityCode: json["securityCode"],
    expiryYear: json["expiryYear"],
    expiryMonth: json["expiryMonth"],
    cardNo: json["cardNo"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "memberId": memberId,
    "type": type,
    "payState": payState,
    "email": email,
    "payName": payName,
    "securityCode": securityCode,
    "expiryYear": expiryYear,
    "expiryMonth": expiryMonth,
    "cardNo": cardNo,
    "notes": notes,
  };
}
