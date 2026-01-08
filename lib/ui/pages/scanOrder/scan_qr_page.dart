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

class _ScanQrPageState extends State<ScanQrPage> with WidgetsBindingObserver {
  late MobileScannerController _controller;
  bool _isScanning = true; // 防止重复扫码

  @override
  void initState() {
    super.initState();
    // 初始化控制器（仅保留核心扫码配置，移除所有闪光灯相关）
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back, // 7.0.1 正确字段名
      formats: const [BarcodeFormat.qrCode], // 仅扫描二维码
      // 移除 torchEnabled 配置，默认关闭闪光灯
    );

    // 监听扫码结果（核心逻辑，无任何改动）
    _controller.barcodes.listen((BarcodeCapture barcodeCapture) {
      if (_isScanning &&
          barcodeCapture.barcodes.isNotEmpty &&
          barcodeCapture.barcodes.first.rawValue != null) {
        _isScanning = false; // 锁定，避免重复触发
        String scanResult = barcodeCapture.barcodes.first.rawValue!;
        Get.back(result: scanResult); // 返回结果到上一页
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 深色背景适配你的页面风格
      body: Stack(
        children: [
          // 扫码预览层（仅保留核心配置，移除errorBuilder外的所有冗余）
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            errorBuilder: (context, error) {
              return Center(
                child: Text(
                  'Camera initialization failed'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          // 仅保留返回按钮，移除闪光灯按钮
          Positioned(
            top: 40.h,
            left: 10.w,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),

          // 扫码框（视觉引导，保留原有风格）
          Center(
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFF760E), width: 2.w),
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.black.withOpacity(0.5),
                backgroundBlendMode: BlendMode.srcOver,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13.r),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // 底部提示文字（保留）
          Positioned(
            bottom: 80.h,
            left: 0,
            right: 0,
            child: Text(
              'Align the QR code within the frame'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FONT_LIGHT,
              ),
            ),
          ),
        ],
      ),
    );
  }
}