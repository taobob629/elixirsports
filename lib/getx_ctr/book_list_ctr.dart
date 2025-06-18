import 'package:elixir_esports/api/booking_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:get/get.dart';

import '../models/booking_list_model.dart';
import '../ui/pages/booking/book_detail_page.dart';

class BookListCtr extends BasePageController {

  static BookListCtr get find => Get.find();

  var bookingListModel = BookingListModel().obs;
  var rowList = <BookingRow>[].obs;

  @override
  void requestData() async {
    bookingListModel.value = await BookingApi.bookingList();
    if (bookingListModel.value.tableDataInfo != null) {
      rowList.assignAll(bookingListModel.value.tableDataInfo!.rows);
    }
  }

  String calNumberOfSeat(String? computers) {
    if (computers == null) {
      return "0";
    }
    String trimmedStr = computers.replaceAll(RegExp(r'^[^,]*|[^,]*$'), '');
    List<String> parts = trimmedStr.split(',');
    return "${parts.length}";
  }

  void jumpDetail(int? id) async {
    await Get.to(() => BookDetailPage(), arguments: id);
    requestData();
  }
}