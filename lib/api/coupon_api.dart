import 'package:elixir_esports/api/wy_http.dart';

import '../models/coupon_list_model.dart';

class CouponApi {
  static Future<CouponListModel> list({
    required int status,
    required int pageNum,
    required int pageSize,
  }) async {
    var response = await http.get('app/user/myCoupons', queryParameters: {
      "available": status,
      "pageNum": 1,
      "pageSize": 1000,
    });
    return CouponListModel.fromJson(response.data);
  }
}
