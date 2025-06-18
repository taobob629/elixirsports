import 'dart:ffi';

import 'package:elixir_esports/api/wy_http.dart';
import 'package:elixir_esports/base/base_http.dart';

import '../models/booking_detail_model.dart';
import '../models/booking_list_model.dart';
import '../models/seat_model.dart';

class BookingApi {
  static Future<SeatModel> list(int storeId) async {
    var response = await http.get('app/booking/storeComputers?storeId=$storeId',
        options: Options(extra: {
          "showLoading": false,
        }));
    return SeatModel.fromJson(response.data);
  }

  static Future<BookingListModel> bookingList() async {
    var response = await http.get('app/user/myBooking');
    return BookingListModel.fromJson(response.data);
  }

  static Future<BookingDetailModel> bookingDetail(int id) async {
    var response =
        await http.get('app/booking/bookingDetail', queryParameters: {
      "id": id,
    });
    return BookingDetailModel.fromJson(response.data);
  }

  // 提交预定
  static Future<BookingDetailModel> submitBooking({
    int? storeId,
    String? areaId,
    required List<String> computers,
  }) async {
    var response = await http.post('app/booking/makeBooking', data: {
      "storeId": storeId,
      "areaId": areaId,
      "computers": computers,
    });
    return BookingDetailModel.fromJson(response.data);
  }

  // 取消预定
  static Future<void> cancelBooking({int? id}) async {
    await http.get('app/booking/cancalBooking', queryParameters: {
      "id": id,
    });
  }
}
