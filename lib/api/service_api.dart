import 'package:elixir_esports/api/wy_http.dart';
import 'package:elixir_esports/base/base_http.dart';

import '../models/booking_detail_model.dart';
import '../models/problem_model.dart';

class ServiceApi {
  static Future<BookingDetailModel> getServiceData() async {
    var response = await http.get('app/service/index',
        options: Options(extra: {
          "showLoading": false,
        }));
    if (response.data == null) {
      return BookingDetailModel(sites: []);
    }
    return BookingDetailModel.fromJson(response.data);
  }

  static Future<List<ProblemModel>> getProblems() async {
    var response = await http.get('app/user/questions');

    List<ProblemModel> list = response.data
        .map<ProblemModel>((item) => ProblemModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<void> getProblemsAnswer(int? id) async {
    await http.get('app/user/clickQuest',
        queryParameters: {"id": id},
        options: Options(extra: {
          "showLoading": false,
        }));
  }
}
