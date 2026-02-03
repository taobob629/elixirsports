class BookingPreModel {
  int? id;
  int? memberId;
  int? storeId;
  String? areaId;
  String? bookingTime;
  String? storeName;
  dynamic areaName;
  String? userName;
  String? price;
  String? orgPrice;
  String? discount;
  String? htmlString;

  List<String>? computers;
  String? phone;
  dynamic bookingBegin;
  String? balance;
  String? points;
  int? freeTime;
  String? address;
  String? map;
  String? endChargeTime;
  List<Site> sites;

  BookingPreModel({
    this.id,
    this.discount,
    this.memberId,
    this.storeId,
    this.htmlString,
    this.orgPrice,
    this.areaId,
    this.bookingTime,
    this.storeName,
    this.areaName,
    this.userName,
    this.computers,
    this.phone,
    this.bookingBegin,
    this.balance,
    this.points,
    this.freeTime,
    this.address,
    this.map,
    this.endChargeTime,
    this.price,
    required this.sites,

  });

  factory BookingPreModel.fromJson(Map<String, dynamic> json) =>
      BookingPreModel(
        id: json["id"],
        memberId: json["memberId"],
        discount: json["discount"],
        orgPrice: json["orgPrice"],

        storeId: json["storeId"],
        htmlString: json["htmlString"],

        areaId: json["areaId"],
        bookingTime: json["bookingTime"],
        storeName: json["storeName"],
        price: json["price"],

        areaName: json["areaName"],
        userName: json["userName"],
        computers: (json['computers'] as List).cast<String>(),
        phone: json["phone"],
        bookingBegin: json["bookingBegin"],

        balance: json["balance"],
        points: json["points"],
        freeTime: json["freeTime"],
        address: json["address"],
        map: json["map"],
        endChargeTime: json["endChargeTime"],
        sites: json["sites"] == null
            ? []
            : List<Site>.from(json["sites"]!.map((x) => Site.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberId": memberId,
        "storeId": storeId,
        "orgPrice":orgPrice,
        "areaId": areaId,
        "bookingTime": bookingTime,
        "discount":discount,
        "storeName": storeName,
        "areaName": areaName,
        "price":price,
        "userName": userName,
        "computers":  computers,
        "htmlString":  htmlString,

        "phone": phone,
        "bookingBegin": bookingBegin,
        "balance": balance,
        "points": points,
        "freeTime": freeTime,
        "address": address,
        "map": map,
        "endChargeTime": endChargeTime,
        "sites": List<dynamic>.from(sites.map((x) => x.toJson())),
      };
}

class Site {
  String? area;
  String? name;

  Site({
    this.area,
    this.name,
  });

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        area: json["area"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "area": area,
        "name": name,
      };
}
