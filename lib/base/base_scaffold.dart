import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/widget/page_title.dart';
import '../utils/color_utils.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  BaseScaffold({
    required this.title,
    this.backgroundColor,
    this.appBarBackgroundColor,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? toColor('F5F5F5'),
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor ?? Colors.white,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: toColor("3d3d3d"),
          ),
        ),
        elevation: 0,
        title: PageTitle(
          title: title,
          color: toColor("3d3d3d"),
        ),
        actions: actions,
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
