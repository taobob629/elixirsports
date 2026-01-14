import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../config/icon_font.dart'; // 你的字体配置
import '../../../getx_ctr/user_controller.dart'; // UserController
// 导入所有必要的包
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

    // 模拟器适配：启动后自动模拟扫码
    _checkEmulatorAndSimulateScan();
  }

  // 判断是否为模拟器
  Future<bool> _isEmulator() async {
    if (!Platform.isAndroid) return false; // 仅处理安卓模拟器
    final AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
    return !info.isPhysicalDevice; // true = 模拟器，false = 真机
  }

  // 显示弹窗让用户输入base64图片数据
  Future<String?> _showBase64InputDialog() async {
    String base64Data = '';
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('输入Base64图片数据'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: '请输入完整的base64图片数据，例如：data:image/png;base64,iVBORw0KGgo...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    base64Data = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, base64Data);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  // 将base64字符串转换为Uint8List
  Uint8List? _base64ToUint8List(String base64Data) {
    try {
      // 处理base64数据，移除前缀（如果有）
      String base64String = base64Data;
      if (base64String.startsWith('data:image/')) {
        base64String = base64String.split(',')[1];
      }
      // 转换为Uint8List
      return base64Decode(base64String);
    } catch (e) {
      print('Base64转换失败：$e');
      return null;
    }
  }

  // 模拟器中模拟扫码（适配mobile_scanner 7.0.1）
  Future<void> _simulateQrScan() async {
    if (!_isScanning) {
      _isScanning = true;
      try {
        // 步骤1：显示弹窗让用户输入base64图片数据
        String? base64Data = await _showBase64InputDialog();
        if (base64Data == null || base64Data.isEmpty) {
          _isScanning = false;
          return;
        }

        // 步骤2：将base64数据转换为Uint8List
        Uint8List? bytes = _base64ToUint8List(base64Data);
        if (bytes == null) {
          _isScanning = false;
          return;
        }

        // 步骤3：保存到模拟器临时目录
        final String tempPath = (await getTemporaryDirectory()).path;
        final File tempFile = File('$tempPath/input_qr_code.png');
        await tempFile.writeAsBytes(bytes);

        // 步骤4：使用图片路径解析二维码（7.0.1的analyzeImage仅支持String路径）
        final BarcodeCapture? capture =
            await _controller?.analyzeImage(tempFile.path);
        if (capture != null && capture.barcodes.isNotEmpty) {
          String? qrContent = capture.barcodes.first.rawValue;
          if (qrContent != null) {
            // 返回扫码结果到上一页（GetX路由）
            Get.back(result: qrContent);
          }
        }
      } catch (e) {
        print('模拟扫码失败：$e');
        _isScanning = false;
      }
    }
  }

  // 检查是否为模拟器，若是则模拟扫码
  Future<void> _checkEmulatorAndSimulateScan() async {
    bool isEmulator = await _isEmulator();
    if (isEmulator) {
      // 延迟1秒，确保控制器初始化完成
      await Future.delayed(const Duration(seconds: 1));
      await _simulateQrScan();
    }
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

  // 从相册选择二维码图片（可选功能）
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final BarcodeCapture? capture =
          await _controller?.analyzeImage(image.path);
      if (capture != null && capture.barcodes.isNotEmpty) {
        Get.back(result: capture.barcodes.first.rawValue);
      }
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
        actions: [
          // 相册选择按钮（可选）
          IconButton(
            icon: const Icon(Icons.photo_library, color: Colors.white),
            onPressed: _pickImageFromGallery,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 扫码预览（真机显示摄像头，模拟器无画面但不影响逻辑）
          MobileScanner(
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
          // 模拟器提示（可选）
          FutureBuilder<bool>(
            future: _isEmulator(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return const Center(
                  child: Text(
                    '模拟器模式：自动识别测试二维码',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
