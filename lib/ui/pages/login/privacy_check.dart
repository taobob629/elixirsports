import 'package:elixir_esports/api/login_api.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/icon_font.dart';
import '../../../models/privacy_model.dart';
import '../webview/web_page.dart';

class PrivacyCheck extends StatelessWidget {
  final _controller = Get.put(_PrivacyCheckController());
  late final PrivacyCheckController controller;
  WrapAlignment wrapAlignment;

  PrivacyCheck({
    super.key,
    required this.controller,
    this.wrapAlignment = WrapAlignment.start,
  }) {
    controller._c = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.offsetAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_controller.offsetAnim.value, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: SizedBox(
                  width: 24.w,
                  child: Obx(() => Checkbox(
                        shape: const CircleBorder(),
                        side: BorderSide(color: Colors.black, width: 2.w),
                        // 设置边框样式,
                        activeColor: toColor('e33e45'),
                        value: _controller.check.value,
                        onChanged: (v) => _controller.check.value = v!,
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: wrapAlignment,
                    runSpacing: 5,
                    children: buildPrivacyItem(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  var textColor = const Color(0xFF141517);

  List<Widget> buildPrivacyItem() {
    List<Widget> items = [];
    items.add(
      Text(
        "By checking this means you agree to our".tr,
        style: TextStyle(
          color: textColor,
          fontFamily: FONT_MEDIUM,
          fontSize: 14.sp,
        ),
      ),
    );
    items.add(
      GestureDetector(
        onTap: () => _controller.requestPrivacy(1),
        child: Text(
          'User Agreement'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontFamily: FONT_MEDIUM,
            fontSize: 14.sp,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
    items.add(
      Text(
        " & ",
        style: TextStyle(
          color: textColor,
          fontFamily: FONT_MEDIUM,
          fontSize: 14.sp,
        ),
      ),
    );
    items.add(
      GestureDetector(
        onTap: () => _controller.requestPrivacy(2),
        child: Text(
          'Privacy Policy'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontFamily: FONT_MEDIUM,
            fontSize: 14.sp,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
    return items;
  }
}

class PrivacyCheckController {
  late _PrivacyCheckController? _c;

  bool check() {
    if (_c != null) {
      if (_c!.check.value == false) {
        _c?.shake();
      }
      return _c!.check.value;
    }
    return false;
  }

  void dispose() {
    _c = null;
  }
}

class _PrivacyCheckController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> offsetAnim;
  var check = false.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    offsetAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 3),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 4),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 6),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 7),
    ]).animate(animationController);

    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.reset();
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void shake() {
    animationController.forward();
  }

  void requestPrivacy(int type) async {
    PrivacyModel model = await LoginApi.privacy(type);
    if (model.title != null && model.content != null) {
      Get.to(() => WebPage(
            title: model.title!,
            url: model.content!,
          ));
    } else {
      showError("data is null".tr);
    }
  }
}
