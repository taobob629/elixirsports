class SeatModel {
  String? image;
  List<Computer> computers;
  List<String> info;

  SeatModel({
    this.image,
    required this.computers,
    required this.info,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) => SeatModel(
        image: json["image"],
        computers: json["computers"] == null
            ? []
            : List<Computer>.from(
                json["computers"]!.map((x) => Computer.fromJson(x))),
        info: json["info"] == null
            ? []
            : List<String>.from(json["info"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "computers": List<dynamic>.from(computers.map((x) => x.toJson())),
        "info": List<dynamic>.from(info.map((x) => x)),
      };
}

class Computer {
  int? id;
  String? name;
  String? areaName;
  int? areaId;
  int? storeId;
  String? price;
  String? sn;
  int? status;
  int? bookingType;
  String? tops;
  String? lefts;
  int? tabId;
  String? rotate;

  Computer({
    this.id,
    this.name,
    this.areaName,
    this.areaId,
    this.storeId,
    this.price,
    this.sn,
    this.status,
    this.bookingType,
    this.tops,
    this.lefts,
    this.tabId,
    this.rotate,
  });

  factory Computer.fromJson(Map<String, dynamic> json) => Computer(
        id: json["id"],
        name: json["name"],
        areaName: json["areaName"],
        areaId: json["areaId"],
        storeId: json["storeId"],
        price: json["price"],
        sn: json["sn"],
        status: json["status"],
        bookingType: json["bookingType"],
        tops: json["tops"],
        lefts: json["lefts"],
        tabId: json["tabId"],
        rotate: json["rotate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "areaName": areaName,
        "areaId": areaId,
        "storeId": storeId,
        "price": price,
        "sn": sn,
        "status": status,
        "bookingType": bookingType,
        "tops": tops,
        "lefts": lefts,
        "tabId": tabId,
        "rotate": rotate,
      };
}
