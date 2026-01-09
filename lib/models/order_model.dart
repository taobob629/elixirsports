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
  final String loginTips;
  final String orderId;
  final String orderTitle;
  final List<GoodsModel> goodsList;
  // final List<CouponModel> couponList;
  final AmountInfo amountInfo;
  final int couponLength;

  OrderData({
    required this.needLogin,
    required this.loginTips,
    required this.orderId,
    required this.orderTitle,
    required this.goodsList,
    // required this.couponList,
    required this.amountInfo,
    required this.couponLength,

  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    var goodsListJson = json['goodsList'] as List;
    List<GoodsModel> goodsList = goodsListJson.map((i) => GoodsModel.fromJson(i)).toList();

    var couponListJson = json['couponList'] as List;
    // List<CouponModel> couponList = couponListJson.map((i) => CouponModel.fromJson(i)).toList();

    return OrderData(
      needLogin: json['needLogin'],
      loginTips: json['loginTips'],
      orderId: json['orderId'],
      couponLength: json['couponLength'],

      orderTitle: json['orderTitle'],
      goodsList: goodsList,
      // couponList: couponList,
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

  GoodsModel({
    required this.goodsId,
    required this.goodsName,
    required this.goodsImage,
    required this.goodsPrice,
    required this.discountType,
    required this.discountAmount,
    required this.count,
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
    );
  }
}

class CouponModel {
  final String couponId;
  final String couponName;
  final double couponValue;

  CouponModel({
    required this.couponId,
    required this.couponName,
    required this.couponValue,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      couponId: json['couponId'],
      couponName: json['couponName'],
      couponValue: json['couponValue'].toDouble(),
    );
  }
}

class AmountInfo {
  final double totalGoodsPrice;
  final double totalDiscountPrice;
  final double selectedCouponValue;
  final double payAmount;

  AmountInfo({
    required this.totalGoodsPrice,
    required this.totalDiscountPrice,
    required this.selectedCouponValue,
    required this.payAmount,
  });

  factory AmountInfo.fromJson(Map<String, dynamic> json) {
    return AmountInfo(
      totalGoodsPrice: json['totalGoodsPrice'].toDouble(),
      totalDiscountPrice: json['totalDiscountPrice'].toDouble(),
      selectedCouponValue: json['selectedCouponValue'].toDouble(),
      payAmount: json['payAmount'].toDouble(),
    );
  }
}