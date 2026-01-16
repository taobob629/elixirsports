class OrderResponse {
  final int code;
  final String msg;
  final OrderData? data;

  OrderResponse({required this.code, required this.msg, this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    try {
      // 检查JSON是否直接包含OrderData字段（没有code和data外层）
      if (json.containsKey('orderId') &&
          json.containsKey('goodsList') &&
          !json.containsKey('code')) {
        // 直接返回OrderData的情况
        return OrderResponse(
          code: 200, // 成功状态码
          msg: 'success',
          data: OrderData.fromJson(json), // 直接将整个JSON解析为OrderData
        );
      } else {
        // 标准格式：包含code、msg和data字段
        return OrderResponse(
          code: json['code'] as int? ?? 0,
          msg: json['msg'] ?? '',
          data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
        );
      }
    } catch (e) {
      print("order failed:$e");
      // 解析失败时返回默认值
      return OrderResponse(
        code: 0,
        msg: 'Parse error: $e',
        data: null,
      );
    }
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
  final List<String> way; // 支付方式列表：balance, alipay, wechat, paynow

  OrderData({
    required this.needLogin,
    required this.openOrder,
    required this.loginTips,
    required this.orderId,
    required this.orderTitle,
    required this.goodsList,
    required this.amountInfo,
    required this.couponLength,
    this.way = const [],
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    var goodsListJson = json['goodsList'] as List? ?? [];
    List<GoodsModel> goodsList =
        goodsListJson.map((i) => GoodsModel.fromJson(i)).toList();
    
    // 解析支付方式列表
    List<String> way = [];
    if (json['way'] != null && json['way'] is List) {
      way = (json['way'] as List).map((e) => e.toString()).toList();
    }
    
    try {
      OrderData(
        needLogin: json['needLogin'] as bool? ?? false,
        openOrder: json['openOrder'] as bool? ?? false,
        loginTips: json['loginTips'] ?? '',
        orderId: json['orderId'] ?? '',
        couponLength: json['couponLength'] as int? ?? 0,
        orderTitle: json['orderTitle'] ?? '',
        goodsList: goodsList,
        amountInfo: AmountInfo.fromJson(json['amountInfo'] ?? {}),
        way: way,
      );
    } catch (e) {
      print("OrderData failed:$e");
    }
    return OrderData(
      needLogin: json['needLogin'] as bool? ?? false,
      openOrder: json['openOrder'] as bool? ?? false,
      loginTips: json['loginTips'] ?? '',
      orderId: json['orderId'] ?? '',
      couponLength: json['couponLength'] as int? ?? 0,
      orderTitle: json['orderTitle'] ?? '',
      goodsList: goodsList,
      amountInfo: AmountInfo.fromJson(json['amountInfo'] ?? {}),
      way: way,
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
    try {
      GoodsModel(
        goodsId: json['goodsId'] ?? '',
        goodsName: json['goodsName'] ?? '',
        goodsImage: json['goodsImage'] ?? '',
        goodsPrice: (json['goodsPrice'] as num?)?.toDouble() ?? 0.0,
        discountType: json['discountType'] ?? '',
        discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
        count: json['count'] as int? ?? 0,
        keyWord:
            (json['keyWord'] as List?)?.map((e) => e.toString()).toList() ?? [],
      );
    } catch (e) {
      print("GoodsModel failed:$e");
    }
    return GoodsModel(
      goodsId: json['goodsId'] ?? '',
      goodsName: json['goodsName'] ?? '',
      goodsImage: json['goodsImage'] ?? '',
      goodsPrice: (json['goodsPrice'] as num?)?.toDouble() ?? 0.0,
      discountType: json['discountType'] ?? '',
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] as int? ?? 0,
      keyWord:
          (json['keyWord'] as List?)?.map((e) => e.toString()).toList() ?? [],
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
    try {
      AmountInfo(
        totalGoodsPrice: (json['totalGoodsPrice'] as num?)?.toDouble() ?? 0.0,
        couponDiscount: (json['couponDiscount'] as num?)?.toDouble() ?? 0.0,
        selectedCouponValue:
            (json['selectedCouponValue'] as num?)?.toDouble() ?? 0.0,
        payAmount: (json['payAmount'] as num?)?.toDouble() ?? 0.0,
        memberDiscountPrice:
            (json['memberDiscountPrice'] as num?)?.toDouble() ?? 0.0,
        tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
        service: (json['service'] as num?)?.toDouble() ?? 0.0,
        subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      print("AmountInfo failed:$e");
    }
    return AmountInfo(
      totalGoodsPrice: (json['totalGoodsPrice'] as num?)?.toDouble() ?? 0.0,
      couponDiscount: (json['couponDiscount'] as num?)?.toDouble() ?? 0.0,
      selectedCouponValue:
          (json['selectedCouponValue'] as num?)?.toDouble() ?? 0.0,
      payAmount: (json['payAmount'] as num?)?.toDouble() ?? 0.0,
      memberDiscountPrice:
          (json['memberDiscountPrice'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      service: (json['service'] as num?)?.toDouble() ?? 0.0,
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
