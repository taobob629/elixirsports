import '../models/im_sig_model.dart';
import 'wy_http.dart';

class ImApi {
  static Future<ImSigModel> login() async {
    var response = await http.get(
      'app/user/getSig',
    );
    return ImSigModel.fromJson(response.data);
  }
}
