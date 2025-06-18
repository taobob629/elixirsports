class BookingListModel {
  TableDataInfo? tableDataInfo;

  BookingListModel({
    this.tableDataInfo,
  });

  factory BookingListModel.fromJson(Map<String, dynamic> json) =>
      BookingListModel(
        tableDataInfo: json["tableDataInfo"] == null
            ? null
            : TableDataInfo.fromJson(json["tableDataInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "tableDataInfo": tableDataInfo?.toJson(),
      };
}

class TableDataInfo {
  int? total;
  List<BookingRow> rows;
  int? code;
  String? msg;

  TableDataInfo({
    this.total,
    required this.rows,
    this.code,
    this.msg,
  });

  factory TableDataInfo.fromJson(Map<String, dynamic> json) => TableDataInfo(
        total: json["total"],
        rows: json["rows"] == null
            ? []
            : List<BookingRow>.from(json["rows"]!.map((x) => BookingRow.fromJson(x))),
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

class BookingRow {
  int? id;
  int? memberId;
  int? storeId;
  int? areaId;
  dynamic beginTime;
  dynamic period;
  dynamic totalComputer;
  int? status;
  dynamic remark;
  String? bookingTime;
  String? storeName;
  dynamic areaName;
  String? memberCode;
  String? computers;
  dynamic phone;
  dynamic bookingBegin;
  int? computerId;
  String? orderSn;
  String balance;
  String points;
  int? freeTime;
  String? code;
  dynamic user;
  dynamic address;
  dynamic openTime;
  DateTime? endChargeTime;
  dynamic sites;
  String? bookKey;

  BookingRow({
    this.id,
    this.memberId,
    this.storeId,
    this.areaId,
    this.beginTime,
    this.period,
    this.totalComputer,
    this.status,
    this.remark,
    this.bookingTime,
    this.storeName,
    this.areaName,
    this.memberCode,
    this.computers,
    this.phone,
    this.bookingBegin,
    this.computerId,
    this.orderSn,
    required this.balance,
    required this.points,
    this.freeTime,
    this.code,
    this.user,
    this.address,
    this.openTime,
    this.endChargeTime,
    this.sites,
    this.bookKey,
  });

  factory BookingRow.fromJson(Map<String, dynamic> json) => BookingRow(
        id: json["id"],
        memberId: json["memberId"],
        storeId: json["storeId"],
        areaId: json["areaId"],
        beginTime: json["beginTime"],
        period: json["period"],
        totalComputer: json["totalComputer"],
        status: json["status"],
        remark: json["remark"],
        bookingTime: json["bookingTime"],
        storeName: json["storeName"],
        areaName: json["areaName"],
        memberCode: json["memberCode"],
        computers: json["computers"],
        phone: json["phone"],
        bookingBegin: json["bookingBegin"],
        computerId: json["computerId"],
        orderSn: json["orderSn"],
        balance: json["balance"] ?? "0",
        points: json["points"] ?? "0",
        freeTime: json["freeTime"],
        code: json["code"],
        user: json["user"],
        address: json["address"],
        openTime: json["openTime"],
        endChargeTime: json["endChargeTime"] == null
            ? null
            : DateTime.parse(json["endChargeTime"]),
        sites: json["sites"],
        bookKey: json["bookKey"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberId": memberId,
        "storeId": storeId,
        "areaId": areaId,
        "beginTime": beginTime,
        "period": period,
        "totalComputer": totalComputer,
        "status": status,
        "remark": remark,
        "bookingTime": bookingTime,
        "storeName": storeName,
        "areaName": areaName,
        "memberCode": memberCode,
        "computers": computers,
        "phone": phone,
        "bookingBegin": bookingBegin,
        "computerId": computerId,
        "orderSn": orderSn,
        "balance": balance,
        "points": points,
        "freeTime": freeTime,
        "code": code,
        "user": user,
        "address": address,
        "openTime": openTime,
        "endChargeTime": endChargeTime?.toIso8601String(),
        "sites": sites,
        "bookKey": bookKey,
      };
}
