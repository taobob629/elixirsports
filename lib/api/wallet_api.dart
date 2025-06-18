import 'package:elixir_esports/api/wy_http.dart';

import '../base/base_http.dart';
import '../models/bank_card_model.dart';
import '../models/coupon_list_model.dart';
import '../models/pay_result_model.dart';
import '../models/pgw_pay_model.dart';
import '../models/wallet_model.dart';

class WalletApi {
  static Future<WalletModel> list({
    required int pageNum,
    required int pageSize,
  }) async {
    var response = await http.get('app/user/myWallet', queryParameters: {
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
    return WalletModel.fromJson(response.data);
  }

  static Future<List<CouponsRow>> topUpCoupons({int? amount}) async {
    var response = await http.get(
      'app/user/topUpCoupons',
      queryParameters: {"amount": amount},
    );
    List<CouponsRow> list = response.data.map<CouponsRow>((item) => CouponsRow.fromJson(item)).toList();
    list.sort((a, b) => b.available!.compareTo(a.available!));
    return list;
  }

  // 计算充值折扣
  static Future<int> calculateCoupons({
    int? voucherId,
    int? amount,
  }) async {
    var response = await http.get('app/user/calculate', queryParameters: {
      "voucherId": voucherId,
      "amount": amount,
    });
    return response.data['discount'];
  }

  // 充值
  static Future<int?> topUp({
    String? amount,
    int? couponId,
  }) async {
    var response = await http.post('app/user/topup',
        data: {
          "amount": amount,
          "couponId": couponId,
        },
        options: Options(extra: {
          "showLoading": false,
        }));
    return response.data == null ? null : response.data['discount'];
  }

  // 或者PGW的支付Token
  static Future<PgwPayModel?> getPGWPaymentTokenAndUrl({
    required Map<String, dynamic> map,
  }) async {
    var response = await http.post('app/pay/2c2p',
        data: map,
        options: Options(extra: {
          "showLoading": false,
        }));
    return PgwPayModel.fromJson(response.data);
  }

  // 获取支付结果
  static Future<PayResultModel?> getPGWPaymentResult({
    required String orderSN,
  }) async {
    var response = await http.get('/app/pay/checkOrderStatus',
        queryParameters: {"orderSN": orderSN},
        options: Options(extra: {
          "showLoading": false,
        }));
    return PayResultModel.fromJson(response.data);
  }

  // 支付结果通知我们后台服务
  static Future<void> payNotifyServer({
    required Map<String, dynamic> map,
  }) async {
    var response = await http.post('web/tool/2c2p/app/notify',
        data: map,
        options: Options(extra: {
          "showLoading": true,
        }));
  }

  // 保存银行卡信息
  static Future<void> saveBankInfo({
    required Map<String, dynamic> map,
  }) async {
    var response = await http.post('app/pay/card/save',
        data: map,
        options: Options(extra: {
          "showLoading": true,
        }));
  }

  // 删除银行卡
  static Future<void> deleteBankCard({
    int? id,
  }) async {
    var response = await http.post('app/pay/card/del',
        data: {"id": id},
        options: Options(extra: {
          "showLoading": true,
        }));
  }

  // 获取银行卡列表
  static Future<List<BankCardModel>> getBankCards() async {
    var response = await http.get('app/pay/card');
    List<BankCardModel> list = response.data.map<BankCardModel>((item) => BankCardModel.fromJson(item)).toList();
    return list;
  }
}
