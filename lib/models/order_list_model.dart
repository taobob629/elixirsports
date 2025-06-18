class OrderListModel {
  TableDataInfo? tableDataInfo;

  OrderListModel({
    this.tableDataInfo,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
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
  List<OrderRow> rows;

  TableDataInfo({
    this.total,
    required this.rows,
  });

  factory TableDataInfo.fromJson(Map<String, dynamic> json) => TableDataInfo(
        total: json["total"],
        rows: json["rows"] == null
            ? []
            : List<OrderRow>.from(
                json["rows"]!.map((x) => OrderRow.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class OrderRow {
  int? id;
  int? memberId;
  dynamic memberCode;
  String? orderSn;
  int? orderStatus;
  String? goodsPrice;
  String? couponPrice;
  String? orderPrice;
  String? actualPrice;
  String? payType;
  String? orderShot;
  String? createTime;
  int? storeId;
  dynamic storeName;
  int? eatin;
  int? stuffId;
  dynamic staffName;
  dynamic sessionId;
  int? manually;
  String? tax;
  List<Item> items;

  OrderRow({
    this.id,
    this.memberId,
    this.memberCode,
    this.orderSn,
    this.orderStatus,
    this.goodsPrice,
    this.couponPrice,
    this.orderPrice,
    this.actualPrice,
    this.payType,
    this.orderShot,
    this.createTime,
    this.storeId,
    this.storeName,
    this.eatin,
    this.stuffId,
    this.staffName,
    this.sessionId,
    this.manually,
    this.tax,
    required this.items,
  });

  factory OrderRow.fromJson(Map<String, dynamic> json) => OrderRow(
        id: json["id"],
        memberId: json["memberId"],
        memberCode: json["memberCode"],
        orderSn: json["orderSn"],
        orderStatus: json["orderStatus"],
        goodsPrice: json["goodsPrice"],
        couponPrice: json["couponPrice"],
        orderPrice: json["orderPrice"],
        actualPrice: json["actualPrice"],
        payType: json["payType"],
        orderShot: json["orderShot"],
        createTime: json["createTime"],
        storeId: json["storeId"],
        storeName: json["storeName"],
        eatin: json["eatin"],
        stuffId: json["stuffId"],
        staffName: json["staffName"],
        sessionId: json["sessionId"],
        manually: json["manually"],
        tax: json["tax"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberId": memberId,
        "memberCode": memberCode,
        "orderSn": orderSn,
        "orderStatus": orderStatus,
        "goodsPrice": goodsPrice,
        "couponPrice": couponPrice,
        "orderPrice": orderPrice,
        "actualPrice": actualPrice,
        "payType": payType,
        "orderShot": orderShot,
        "createTime": createTime,
        "storeId": storeId,
        "storeName": storeName,
        "eatin": eatin,
        "stuffId": stuffId,
        "staffName": staffName,
        "sessionId": sessionId,
        "manually": manually,
        "tax": tax,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  double? price;
  int? num;
  String? name;
  String? image;

  Item({
    this.price,
    this.num,
    this.name,
    this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        price: json["price"]?.toDouble(),
        num: json["num"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "num": num,
        "name": name,
        "image": image,
      };
}
