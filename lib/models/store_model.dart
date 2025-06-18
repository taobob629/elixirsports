class StoreModel {
  int? id;
  String? name;
  String? address;
  String? postCode;
  String? telephone;
  String? headImage;
  String? images;
  String? email;
  String? createBy;
  String? openTime;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? manager;
  int? booking;
  String? map;
  String? album;
  String? serviceAccount;

  StoreModel({
    this.id,
    this.name,
    this.address,
    this.postCode,
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
    this.serviceAccount,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    postCode: json["postCode"],
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
    serviceAccount: json["serviceAccount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "postCode": postCode,
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
    "serviceAccount": serviceAccount,
  };
}
