import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_error_widget.dart';

void showErrorWidget(String message) {
  var shouldRemoveOverlay = false.obs;
  final overlayState = Overlay.of(Get.context!);
  final overlayEntry = OverlayEntry(
    builder: (BuildContext context) => Obx(() => AnimatedOpacity(
      opacity: shouldRemoveOverlay.value ? 0 : 1,
      duration: const Duration(seconds: 1),
      child: CustomErrorWidget(message),
    )),
  );
  overlayState.insert(overlayEntry);

  // 慢慢消失
  Future.delayed(const Duration(seconds: 1), () {
    shouldRemoveOverlay.value = true;
  });

  Future.delayed(const Duration(seconds: 2)).then((_) {
    overlayEntry.remove();
  });
}
