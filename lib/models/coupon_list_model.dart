class CouponListModel {
  Coupons? coupons;

  CouponListModel({
    this.coupons,
  });

  factory CouponListModel.fromJson(Map<String, dynamic> json) =>
      CouponListModel(
        coupons:
            json["coupons"] == null ? null : Coupons.fromJson(json["coupons"]),
      );

  Map<String, dynamic> toJson() => {
        "coupons": coupons?.toJson(),
      };
}

class Coupons {
  int? total;
  List<CouponsRow> rows;
  int? code;
  dynamic msg;

  Coupons({
    this.total,
    required this.rows,
    this.code,
    this.msg,
  });

  factory Coupons.fromJson(Map<String, dynamic> json) => Coupons(
        total: json["total"],
        rows: json["rows"] == null
            ? []
            : List<CouponsRow>.from(
                json["rows"]!.map((x) => CouponsRow.fromJson(x))),
        code: json["code"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
        "code": code,
        "msg": msg,
      };
}

class CouponsRow {
  String? note;
  String? unit;
  String? usedTime;
  String? expireTime;
  int? couponType;
  int? id;
  int? available;
  String? name;
  String? value;

  CouponsRow({
    this.note,
    this.unit,
    this.usedTime,
    this.expireTime,
    this.couponType,
    this.id,
    this.available,
    this.name,
    this.value,
  });

  factory CouponsRow.fromJson(Map<String, dynamic> json) => CouponsRow(
        note: json["note"],
        unit: json["unit"],
        usedTime: json["usedTime"],
        expireTime: json["expireTime"],
        couponType: json["couponType"],
        id: json["id"],
        available: json["available"] ?? 0,
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "note": note,
        "unit": unit,
        "usedTime": usedTime,
        "expireTime": expireTime,
        "couponType": couponType,
        "id": id,
        "available": available,
        "name": name,
        "value": value,
      };
}
