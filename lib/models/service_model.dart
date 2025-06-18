class ServiceModel {
  int? id;
  int? memberId;
  int? storeId;
  dynamic endChargeTime;
  int? status;
  String? bookingTime;
  dynamic remark;
  int? areaId;
  String? memberCode;
  String? computers;
  String? balance;
  String? points;
  int? freeTime;
  int? computerId;
  String? orderSn;
  String? code;
  dynamic user;
  String? bookKey;

  ServiceModel({
    this.id,
    this.memberId,
    this.storeId,
    this.endChargeTime,
    this.status,
    this.bookingTime,
    this.remark,
    this.areaId,
    this.memberCode,
    this.computers,
    this.balance,
    this.points,
    this.freeTime,
    this.computerId,
    this.orderSn,
    this.code,
    this.user,
    this.bookKey,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json["id"],
    memberId: json["memberId"],
    storeId: json["storeId"],
    endChargeTime: json["endChargeTime"],
    status: json["status"],
    bookingTime: json["bookingTime"],
    remark: json["remark"],
    areaId: json["areaId"],
    memberCode: json["memberCode"],
    computers: json["computers"],
    balance: json["balance"],
    points: json["points"],
    freeTime: json["freeTime"],
    computerId: json["computerId"],
    orderSn: json["orderSn"],
    code: json["code"],
    user: json["user"],
    bookKey: json["bookKey"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "memberId": memberId,
    "storeId": storeId,
    "endChargeTime": endChargeTime,
    "status": status,
    "bookingTime": bookingTime,
    "remark": remark,
    "areaId": areaId,
    "memberCode": memberCode,
    "computers": computers,
    "balance": balance,
    "points": points,
    "freeTime": freeTime,
    "computerId": computerId,
    "orderSn": orderSn,
    "code": code,
    "user": user,
    "bookKey": bookKey,
  };
}
