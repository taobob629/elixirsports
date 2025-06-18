class WalletModel {
  String reward;
  String? memberCode;
  String? phone;
  int? level;
  String? nickName;
  String? sex;
  int? id;
  int? userType;
  String? avatar;
  CashRecord? cashRecord;
  String cash;

  WalletModel({
    required this.reward,
    this.memberCode,
    this.phone,
    this.level,
    this.nickName,
    this.sex,
    this.id,
    this.userType,
    this.avatar,
    this.cashRecord,
    required this.cash,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        reward: json["reward"] ?? '0',
        memberCode: json["memberCode"],
        phone: json["phone"],
        level: json["level"],
        nickName: json["nickName"],
        sex: json["sex"],
        id: json["id"],
        userType: json["userType"],
        avatar: json["avatar"],
        cashRecord: json["cashRecord"] == null
            ? null
            : CashRecord.fromJson(json["cashRecord"]),
        cash: json["cash"] ?? '0',
      );
}

class CashRecord {
  int? total;
  List<WalletRow> rows;

  CashRecord({
    this.total,
    required this.rows,
  });

  factory CashRecord.fromJson(Map<String, dynamic> json) => CashRecord(
        total: json["total"],
        rows: json["rows"] == null
            ? []
            : List<WalletRow>.from(
                json["rows"]!.map((x) => WalletRow.fromJson(x))),
      );
}

class WalletRow {
  String? reward;
  String? unit;
  int? color;
  String? money;
  String? name;
  String? time;
  String? payWay;

  WalletRow({
    this.reward,
    this.color,
    this.money,
    this.unit,
    this.name,
    this.time,
    this.payWay,
  });

  factory WalletRow.fromJson(Map<String, dynamic> json) => WalletRow(
        reward: json["reward"],
        color: json["color"],
        money: json["money"],
        unit: json["unit"],
        name: json["name"],
        time: json["time"],
        payWay: json["payWay"],
      );
}
