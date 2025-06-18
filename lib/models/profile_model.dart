class ProfileModel {
  String? reward;
  String? balance;
  int? coupon;
  int? level;
  String? uk;
  String? name;
  List<MemberShip> memberShip;
  String? avatar;
  bool? isServiceAccount;
  bool? topup;

  ProfileModel({
    this.reward,
    this.balance,
    this.coupon,
    this.level,
    this.uk,
    this.name,
    required this.memberShip,
    this.isServiceAccount,
    this.topup,
    this.avatar,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        reward: json["reward"],
        balance: json["balance"],
        coupon: json["coupon"],
        level: json["level"],
        uk: json["uk"],
        name: json["name"],
        memberShip: json["memberShip"] == null
            ? []
            : List<MemberShip>.from(
                json["memberShip"]!.map((x) => MemberShip.fromJson(x))),
        avatar: json["avatar"],
        isServiceAccount: json["isServiceAccount"] ?? false,
        topup: json["topup"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "reward": reward,
        "balance": balance,
        "coupon": coupon,
        "level": level,
        "uk": uk,
        "name": name,
        "memberShip": List<dynamic>.from(memberShip.map((x) => x.toJson())),
        "avatar": avatar,
      };
}

class MemberShip {
  int? id;
  String? name;
  String? price;
  String? coupons;
  String? content;
  int? enabled;
  String? note;
  int? level;
  int? language;

  MemberShip({
    this.id,
    this.name,
    this.price,
    this.coupons,
    this.content,
    this.enabled,
    this.note,
    this.level,
    this.language,
  });

  factory MemberShip.fromJson(Map<String, dynamic> json) => MemberShip(
        id: json["id"],
        name: json["name"],
        price: json["price"] == null
            ? '0'
            : json["price"].toString().split(".")[0],
        coupons: json["coupons"],
        content: json["content"],
        enabled: json["enabled"],
        note: json["note"],
        level: json["level"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "coupons": coupons,
        "content": content,
        "enabled": enabled,
        "note": note,
        "level": level,
        "language": language,
      };
}

class ContentModel {
  String title;
  List<DescriptionItem> description;

  ContentModel({required this.title, required this.description});

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      title: json['title'],
      description: List<DescriptionItem>.from(
          json['description'].map((x) => DescriptionItem.fromJson(x))),
    );
  }
}

class DescriptionItem {
  String value;

  DescriptionItem({required this.value});

  factory DescriptionItem.fromJson(Map<String, dynamic> json) {
    return DescriptionItem(value: json['value']);
  }
}
