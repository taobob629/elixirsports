class BookingDetailModel {
  int? id;
  int? memberId;
  int? storeId;
  int? areaId;
  int? status;
  dynamic remark;
  String? bookingTime;
  String? storeName;
  dynamic areaName;
  String? memberCode;
  String? computers;
  String? phone;
  dynamic bookingBegin;
  int? computerId;
  String? orderSn;
  String? balance;
  String? points;
  int? freeTime;
  dynamic code;
  dynamic user;
  String? address;
  String? postCode;
  String? map;
  String? openTime;
  String? endChargeTime;
  List<Site> sites;
  String? bookKey;

  BookingDetailModel({
    this.id,
    this.memberId,
    this.storeId,
    this.areaId,
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
    this.balance,
    this.points,
    this.freeTime,
    this.code,
    this.user,
    this.address,
    this.postCode,
    this.map,
    this.openTime,
    this.endChargeTime,
    required this.sites,
    this.bookKey,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) =>
      BookingDetailModel(
        id: json["id"],
        memberId: json["memberId"],
        storeId: json["storeId"],
        areaId: json["areaId"],
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
        balance: json["balance"],
        points: json["points"],
        freeTime: json["freeTime"],
        code: json["code"],
        user: json["user"],
        address: json["address"],
        postCode: json["postCode"],
        map: json["map"],
        openTime: json["openTime"],
        endChargeTime: json["endChargeTime"],
        sites: json["sites"] == null
            ? []
            : List<Site>.from(json["sites"]!.map((x) => Site.fromJson(x))),
        bookKey: json["bookKey"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberId": memberId,
        "storeId": storeId,
        "areaId": areaId,
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
        "map": map,
        "openTime": openTime,
        "endChargeTime": endChargeTime,
        "sites": List<dynamic>.from(sites.map((x) => x.toJson())),
        "bookKey": bookKey,
      };
}

class Site {
  String? area;
  String? price;
  String? name;

  Site({
    this.area,
    this.price,
    this.name,
  });

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        area: json["area"],
        price: json["price"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "area": area,
        "price": price,
        "name": name,
      };
}
