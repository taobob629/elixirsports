import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../base/base_scaffold.dart';

class ScanPage extends StatelessWidget {
  final controller = Get.put(ScanPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Scan QR code".tr,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: MobileScanner(
            controller: controller.scanCtr,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                controller.scanCtr?.stop();
                Get.back(result: barcodes.first.rawValue);
                print("barcodes.first.rawValue ${barcodes.first.rawValue}");
              }
            },
          )),
    );
  }
}

class ScanPageController extends GetxController {
  MobileScannerController? scanCtr;

  @override
  void onInit() {
    super.onInit();
    scanCtr = MobileScannerController();
  }

  @override
  void onClose() {
    scanCtr?.stop();
    super.onClose();
  }
}
