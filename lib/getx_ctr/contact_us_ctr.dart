import 'package:elixir_esports/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/service_api.dart';
import '../models/problem_model.dart';

class ContactUsCtr extends BasePageController {
  static ContactUsCtr get find => Get.find();

  var list = <ProblemModel>[].obs;

  // 提问过的问题集合
  var selectProblemList = <ProblemModel>[].obs;

  final ScrollController scrollController = ScrollController();

  @override
  void requestData() async {
    list.value = await ServiceApi.getProblems();
  }

  void getProblemsAnswer(ProblemModel model) async {
    selectProblemList.add(model);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
    await ServiceApi.getProblemsAnswer(model.id);
  }
}
