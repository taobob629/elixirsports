import 'package:elixir_esports/api/wy_http.dart';

import '../models/scan_model.dart';

class ScanApi {
  static Future<ScanModel> scanInfo({
    required String data,
  }) async {
    var response = await http.get('app/service/scanInfo', queryParameters: {
      "data": data,
    });
    return ScanModel.fromJson(response.data);
  }

  static Future<ScanModel> scanLogin({
    String? ip,
    int? storeId,
  }) async {
    var response = await http.get('app/service/scanLogin', queryParameters: {
      "ip": ip,
      "storeId": storeId,
    });
    return ScanModel.fromJson(response.data);
  }
}
