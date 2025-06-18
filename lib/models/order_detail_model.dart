class OrderDetailModel {
  String? total;
  String? address;
  String? orderSn;
  String? discount;
  String? tax;
  String? tel;
  String? time;
  String? subTotal;
  String? store;
  dynamic map;
  List<OrderDetailItem> items;
  int? status;

  OrderDetailModel({
    this.total,
    this.address,
    this.orderSn,
    this.discount,
    this.tax,
    this.tel,
    this.time,
    this.subTotal,
    this.store,
    this.map,
    required this.items,
    this.status,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        total: json["total"],
        address: json["address"],
        orderSn: json["orderSn"],
        discount: json["discount"],
        tax: json["tax"],
        tel: json["tel"],
        time: json["time"],
        subTotal: json["subTotal"],
        store: json["store"],
        map: json["map"],
        items: json["items"] == null
            ? []
            : List<OrderDetailItem>.from(
                json["items"]!.map((x) => OrderDetailItem.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "address": address,
        "orderSn": orderSn,
        "discount": discount,
        "tax": tax,
        "tel": tel,
        "time": time,
        "subTotal": subTotal,
        "store": store,
        "map": map,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "status": status,
      };
}

class OrderDetailItem {
  int? num;
  String? name;
  double? price;
  String? image;

  OrderDetailItem({
    this.num,
    this.name,
    this.price,
    this.image,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) =>
      OrderDetailItem(
        num: json["num"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "num": num,
        "name": name,
        "price": price,
        "image": image,
      };
}
