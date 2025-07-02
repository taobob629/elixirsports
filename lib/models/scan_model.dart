class ScanModel {
  String? reward;
  String? price;
  String? ip;
  String? freeTime;
  String? pcName;
  String? name;
  String? discount;
  StoreInfo? storeInfo;
  String? avatar;
  int? storeId;
  String? cash;
  String? msg;

  ScanModel({
    this.reward,
    this.price,
    this.ip,
    this.freeTime,
    this.pcName,
    this.name,
    this.discount,
    this.storeInfo,
    this.avatar,
    this.storeId,
    this.cash,
    this.msg,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
    reward: json["reward"],
    price: json["price"],
    ip: json["ip"],
    freeTime: json["freeTime"],
    pcName: json["pcName"],
    name: json["name"],
    discount: json["discount"],
    storeInfo: json["storeInfo"] == null ? null : StoreInfo.fromJson(json["storeInfo"]),
    avatar: json["avatar"],
    storeId: json["storeId"],
    cash: json["cash"],
    msg: json["msg"],

  );

  Map<String, dynamic> toJson() => {
    "reward": reward,
    "price": price,
    "ip": ip,
    "freeTime": freeTime,
    "pcName": pcName,
    "name": name,
    "discount": discount,
    "storeInfo": storeInfo?.toJson(),
    "avatar": avatar,
    "storeId": storeId,
    "cash": cash,
    "msg": msg,

  };
}

class StoreInfo {
  int? id;
  String? name;
  String? address;
  String? telephone;
  String? headImage;
  dynamic images;
  String? email;
  String? createBy;
  String? openTime;
  String? createTime;
  String? updateBy;
  String? updateTime;
  dynamic remark;
  int? manager;
  int? booking;
  String? map;
  String? album;
  String? taxRate;

  StoreInfo({
    this.id,
    this.name,
    this.address,
    this.telephone,
    this.headImage,
    this.images,
    this.email,
    this.createBy,
    this.openTime,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.manager,
    this.booking,
    this.map,
    this.album,
    this.taxRate,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) => StoreInfo(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    telephone: json["telephone"],
    headImage: json["headImage"],
    images: json["images"],
    email: json["email"],
    createBy: json["createBy"],
    openTime: json["openTime"],
    createTime: json["createTime"],
    updateBy: json["updateBy"],
    updateTime: json["updateTime"],
    remark: json["remark"],
    manager: json["manager"],
    booking: json["booking"],
    map: json["map"],
    album: json["album"],
    taxRate: json["taxRate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "telephone": telephone,
    "headImage": headImage,
    "images": images,
    "email": email,
    "createBy": createBy,
    "openTime": openTime,
    "createTime": createTime,
    "updateBy": updateBy,
    "updateTime": updateTime,
    "remark": remark,
    "manager": manager,
    "booking": booking,
    "map": map,
    "album": album,
    "taxRate": taxRate,
  };
}
