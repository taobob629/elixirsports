import 'package:elixir_esports/api/booking_api.dart';
import 'package:elixir_esports/base/base_controller.dart';
import 'package:elixir_esports/getx_ctr/service_ctr.dart';
import 'package:elixir_esports/utils/decimal_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets_utils.dart';
import '../models/seat_model.dart';
import '../models/store_model.dart';
import '../ui/dialog/confirm_dialog.dart';
import '../ui/pages/booking/book_detail_page.dart';
import '../ui/pages/booking/per_booking_page.dart';

class BookSeatCtr extends BasePageController {
  static BookSeatCtr get find => Get.find();

  var seatModel = SeatModel(computers: [], info: []).obs;

  // 选择的座位
  var selectSeatList = <Computer>[].obs;
  var totalPrice = "0".obs;

  var loadComplete = false.obs;

  late StoreModel storeModel;

  @override
  void requestData() async {
    storeModel = Get.arguments;

    showLoading();
    seatModel.value = await BookingApi.list(storeModel.id!);
    pageState = 4;
  }

  String getSeatDirectionIcon(Computer computer) {
    switch (computer.rotate) {
      case "-90":
        switch (computer.status) {
          // 0：可用；1：已占用；2：已预订；3：不可用,5:维护中
          case 1:
            return AssetsUtils.seat_red_left_icon;
          case 2:
            return AssetsUtils.seat_purple_left_icon;
          case 3:
            return AssetsUtils.seat_gray_left_icon;
          case 4:
            return AssetsUtils.seat_green_left_icon;
          case 5:
            return AssetsUtils.seat_orange_left_icon;

          default:
            return AssetsUtils.seat_white_left_icon;
        }

      case "90":
        switch (computer.status) {
          // 0：可用；1：已占用；2：已预订；3：不可用
          case 1:
            return AssetsUtils.seat_red_right_icon;
          case 2:
            return AssetsUtils.seat_purple_right_icon;
          case 3:
            return AssetsUtils.seat_gray_right_icon;
          case 4:
            return AssetsUtils.seat_green_right_icon;
          case 5:
            return AssetsUtils.seat_orange_right_icon;
          default:
            return AssetsUtils.seat_white_right_icon;
        }

      case "180":
        switch (computer.status) {
          // 0：可用；1：已占用；2：已预订；3：不可用
          case 1:
            return AssetsUtils.seat_red_down_icon;
          case 2:
            return AssetsUtils.seat_purple_down_icon;
          case 3:
            return AssetsUtils.seat_gray_down_icon;
          case 4:
            return AssetsUtils.seat_green_down_icon;
          case 5:
            return AssetsUtils.seat_orange_down_icon;
          default:
            return AssetsUtils.seat_white_down_icon;
        }

      default:
        switch (computer.status) {
          // 0：可用；1：已占用；2：已预订；3：不可用
          case 1:
            return AssetsUtils.seat_red_icon;
          case 2:
            return AssetsUtils.seat_purple_icon;
          case 3:
            return AssetsUtils.seat_gray_icon;
          case 4:
            return AssetsUtils.seat_green_icon;
          case 5:
            return AssetsUtils.seat_orange_icon;
          default:
            return AssetsUtils.seat_white_icon;
        }
    }
  }

  void selectSeat(Computer computer) {
    if (computer.status == 0 || computer.status == 4) {
      // 可用
      if (computer.status == 0) {
        if (computer.bookingType == 1) {
          // 相同区域的全部选择
          if (selectSeatList.isNotEmpty) {
            // 如果之前选择了一个区域，那选择另外一个区域的时候需要清空之前的选择
            for (var element in selectSeatList) {
              element.status = 0;
            }
            selectSeatList.clear();
          }

          // 修复：只选择该区域的可用座位
          final list = seatModel.value.computers.where((element) => element.areaId == computer.areaId && element.status == 0).toList();
          for (var element in list) {
            element.status = 4;
          }
          selectSeatList.addAll(list);
          seatModel.refresh();
        } else {
          // 区域id不相同则清空，相同则不清空
          if (selectSeatList.isNotEmpty) {
            if (selectSeatList[0].areaId != computer.areaId) {
              for (var element in selectSeatList) {
                element.status = 0;
              }
              selectSeatList.clear();
            }
          }
          seatModel.value.computers.firstWhereOrNull((element) => element.id == computer.id)?.status = 4;
          selectSeatList.add(computer);
          seatModel.refresh();
        }
      } else {
        if (computer.bookingType == 1) {
          // 修复：只取消该区域的已选择座位
          final list = seatModel.value.computers.where((element) => element.areaId == computer.areaId && element.status == 4).toList();
          for (var element in list) {
            element.status = 0;
          }
          selectSeatList.removeWhere((element) => element.areaId == computer.areaId);
          seatModel.refresh();
        } else {
          seatModel.value.computers.firstWhereOrNull((element) => element.id == computer.id)?.status = 0;
          selectSeatList.remove(computer);
          seatModel.refresh();
        }
      }
    }

    totalPrice.value = selectSeatList.fold<String>("0", (previousValue, element) => previousValue.add(element.price ?? "0"));
  }

  void cancelSelectSeat() {
    for (var seat in selectSeatList) {
      seatModel.value.computers.firstWhereOrNull((element) => element.id == seat.id)?.status = 0;
    }
    seatModel.refresh();
    selectSeatList.clear();

    totalPrice.value = "0";
  }

  void bookASeat(BuildContext context) async {
    if (selectSeatList.isEmpty) {
      showToast("Please select a seat".tr);
      return;
    }

    final value = await Get.dialog(
      ConfirmDialog(
        title: 'CONFIRM'.tr,
        info: seatModel.value.info.join("\n"),
        htmlString: seatModel.value.htmlString,
      ),
      barrierColor: Colors.black26,
    );
    if (value == null) return;

    List<String> idsArr = selectSeatList.map((computer) => computer.id.toString()).toList();

    final result = await BookingApi.submitBooking(
      storeId: storeModel.id,
      areaId: selectSeatList[0].areaId.toString(),
      computers: idsArr,
    );
    if (result.id != null) {
      if (Get.isRegistered<ServiceCtr>()) {
        ServiceCtr.find.requestData();
      }
      Get.offUntil(
        GetPageRoute(
          settings: RouteSettings(arguments: result.id),
          page: () => BookDetailPage(),
        ),
        (route) => route.isFirst,
      );
    }
  }


  void preBookSeat(BuildContext context) async {
    if (selectSeatList.isEmpty) {
      showToast("Please select a seat".tr);
      return;
    }



    List<String> idsArr = selectSeatList.map((computer) => computer.id.toString()).toList();

    final BookingPreModel = await BookingApi.appPreBookingInfo(
      storeId: storeModel.id,
      areaId: selectSeatList[0].areaId.toString(),
      computers: idsArr,
    );
    if (BookingPreModel != null) {
      // 导航到PerBookingPage，但不等待返回
      Get.to(() => PerBookingPage(), arguments: BookingPreModel);

      if (Get.isRegistered<ServiceCtr>()) {
        ServiceCtr.find.requestData();
      }

    }
  }

}
