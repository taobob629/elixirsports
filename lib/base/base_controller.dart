/**
    author:mac
    创建日期:2023/2/12
    描述:
 */
import 'package:get/get.dart';

import 'empty_view.dart';

class PageState {
  static const int initialing = 0;
  static const int loaded = 1;
  static const int err = 2;
  static const int empty = 3;
  static const int success = 4;
}

abstract class BasePageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RxInt _pageState = RxInt(PageState.initialing);

  int get pageState => _pageState.value;

  set pageState(int value) {
    _pageState.value = value;
  }

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData();
}
