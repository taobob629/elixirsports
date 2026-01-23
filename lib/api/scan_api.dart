import 'package:elixir_esports/api/wy_http.dart';
import 'package:elixir_esports/utils/toast_utils.dart';

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
    String? type,
    String? deviceKey,
  }) async {
    var response = await http.get('app/service/scanLogin', queryParameters: {
      "ip": ip,
      "storeId": storeId,
      "type": type,
      "deviceKey":deviceKey,

    });

    // 添加null检查，避免response.data为null时崩溃
    Map<String, dynamic> data = response.data is Map<String, dynamic> ? response.data : {};
    ScanModel model=ScanModel.fromJson(data);
    if(response.statusCode==200){
      if(model!=null&&model.msg!=null)
        showInfo(model.msg);
    }
    return model;
  }
}
