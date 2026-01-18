import 'package:elixir_esports/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class GetxRefreshController<T> extends BasePageController {
  /// 分页第一页页码
  static const int pageNumFirst = 1;

  var initializing = true.obs;

  /// 分页条目数量
  int pageSize = 20;

  /// 当前页码
  int _currentPageNum = pageNumFirst;

  bool initialRefresh = false;

  RxList<T> list = RxList();

  @override
  void onReady() {
    super.onReady();
    initData();
  }

  initData() async {
    await onRefresh(init: true);
    initializing.value = false;
  }

  Future<List<T>> loadData({int pageNum = 1});

  Future<void> onRefresh({bool init = false}) async {
    try {
      _currentPageNum = pageNumFirst;
      var data = await loadData(pageNum: pageNumFirst);
      if (data.isEmpty) {
        list.clear();
      } else {
        list.clear();
        list.addAll(data);
      }
    } catch (e) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) list.clear();
    }
  }

  Future<void> loadMore() async {
    try {
      var data = await loadData(pageNum: ++_currentPageNum);
      if (data.isEmpty) {
        _currentPageNum--;
      } else {
        list.addAll(data);
      }
    } catch (e) {
      _currentPageNum--;
    }
  }
}
