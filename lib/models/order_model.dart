class OrderResponse {
  final int code;
  final String msg;
  final OrderData? data;

  OrderResponse({required this.code, required this.msg, this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      code: json['code'],
      msg: json['msg'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final bool needLogin;
  final bool openOrder;

  final String loginTips;
  final String orderId;
  final String orderTitle;
  final List<GoodsModel> goodsList;
  final AmountInfo amountInfo;
  final int couponLength;

  OrderData({
    required this.needLogin,
    required this.openOrder,

    required this.loginTips,
    required this.orderId,
    required this.orderTitle,
    required this.goodsList,
    required this.amountInfo,
    required this.couponLength,

  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    var goodsListJson = json['goodsList'] as List;
    List<GoodsModel> goodsList = goodsListJson.map((i) => GoodsModel.fromJson(i)).toList();

    return OrderData(
      needLogin: json['needLogin'],
      openOrder: json['openOrder'],
      loginTips: json['loginTips'],
      orderId: json['orderId'],
      couponLength: json['couponLength'],
      orderTitle: json['orderTitle'],
      goodsList: goodsList,
      amountInfo: AmountInfo.fromJson(json['amountInfo']),
    );
  }
}

class GoodsModel {
  final String goodsId;
  final String goodsName;
  final String goodsImage;
  final double goodsPrice;
  final String discountType;
  final double discountAmount;
  final int count;
  final List<String> keyWord; // 纯字符串

  GoodsModel({
    required this.goodsId,
    required this.goodsName,
    required this.goodsImage,
    required this.goodsPrice,
    required this.discountType,
    required this.discountAmount,
    required this.count,
    required this.keyWord,

  });

  factory GoodsModel.fromJson(Map<String, dynamic> json) {
    return GoodsModel(
      goodsId: json['goodsId'],
      goodsName: json['goodsName'],
      goodsImage: json['goodsImage'],
      goodsPrice: json['goodsPrice'].toDouble(),
      discountType: json['discountType'],
      discountAmount: json['discountAmount'].toDouble(),
      count: json['count'],
      keyWord: (json['keyWord'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}


class AmountInfo {
  final double totalGoodsPrice;
  final double selectedCouponValue;
  final double payAmount;
  final double memberDiscountPrice;
  final double tax;
  final double service;
  final double subTotal;
  final double couponDiscount;




  AmountInfo({
    required this.totalGoodsPrice,
    required this.couponDiscount,
    required this.selectedCouponValue,
    required this.payAmount,
    required this.memberDiscountPrice,
    required this.tax,
    required this.service,
    required this.subTotal,


  });

  factory AmountInfo.fromJson(Map<String, dynamic> json) {
    return AmountInfo(
      totalGoodsPrice: json['totalGoodsPrice'].toDouble(),
      couponDiscount: json['couponDiscount'].toDouble(),
      selectedCouponValue: json['selectedCouponValue'].toDouble(),
      payAmount: json['payAmount'].toDouble(),
      memberDiscountPrice: json['memberDiscountPrice'].toDouble(),
      tax: json['tax'].toDouble(),
      service: json['service'].toDouble(),
      subTotal: json['subTotal'].toDouble(),


    );
  }
}