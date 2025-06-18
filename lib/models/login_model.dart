class LoginModel {
  UserModel? user;
  String? token;

  LoginModel({
    this.user,
    this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };
}

class UserModel {
  int? id;
  String? sex;
  String? phone;
  String? email;
  DateTime? birth;
  String? memberCode;
  int? memberLevel;
  String? balance;
  String? points;
  DateTime? createTime;
  String? memberPhoto;
  String? nickName;

  UserModel({
    this.id,
    this.sex,
    this.phone,
    this.email,
    this.birth,
    this.memberCode,
    this.memberLevel,
    this.balance,
    this.points,
    this.createTime,
    this.memberPhoto,
    this.nickName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    sex: json["sex"],
    phone: json["phone"],
    email: json["email"],
    birth: json["birth"] == null ? null : DateTime.parse(json["birth"]),
    memberCode: json["memberCode"],
    memberLevel: json["memberLevel"],
    balance: json["balance"],
    points: json["points"],
    createTime: json["createTime"] == null ? null : DateTime.parse(json["createTime"]),
    memberPhoto: json["memberPhoto"],
    nickName: json["nickName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sex": sex,
    "phone": phone,
    "email": email,
    "birth": "${birth!.year.toString().padLeft(4, '0')}-${birth!.month.toString().padLeft(2, '0')}-${birth!.day.toString().padLeft(2, '0')}",
    "memberCode": memberCode,
    "memberLevel": memberLevel,
    "balance": balance,
    "points": points,
    "createTime": createTime?.toIso8601String(),
    "memberPhoto": memberPhoto,
    "nickName": nickName,
  };
}
