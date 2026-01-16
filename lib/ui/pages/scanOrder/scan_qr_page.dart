import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../config/icon_font.dart'; // 你的字体配置
import '../../../getx_ctr/user_controller.dart'; // UserController

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  MobileScannerController? _controller;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    // 初始化扫码控制器
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      autoStart: true,
    );
  }

  // 真机扫码回调
  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && !_isScanning) {
      _isScanning = true;
      String? qrContent = barcodes.first.rawValue;
      Get.back(result: qrContent); // 返回结果
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(), // 关闭扫码页
        ),
        actions: [], // 移除相册选择按钮
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
        // 修复：移除多余的 child 参数，仅保留 context 和 error
        errorBuilder: (context, error) {
          return Center(
            child: Text(
              'Scanner error: $error',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
