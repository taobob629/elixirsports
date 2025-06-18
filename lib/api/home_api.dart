import 'package:elixir_esports/api/wy_http.dart';
import 'package:elixir_esports/models/store_model.dart';

class HomeApi {
  static Future<List<StoreModel>> getStoresList() async {
    var response = await http.get('app/home/stores');
    List<StoreModel> list = response.data
        .map<StoreModel>((item) => StoreModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<StoreModel>> search(String value) async {
    var response = await http.get('app/home/search', queryParameters: {
      "key": value
    });
    List<StoreModel> list = response.data
        .map<StoreModel>((item) => StoreModel.fromJson(item))
        .toList();
    return list;
  }
}
