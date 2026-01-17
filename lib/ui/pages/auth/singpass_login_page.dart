import 'package:elixir_esports/services/singpass_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// Singpass 登录页面
class SingpassLoginPage extends StatefulWidget {
  const SingpassLoginPage({Key? key}) : super(key: key);

  @override
  State<SingpassLoginPage> createState() => _SingpassLoginPageState();
}

class _SingpassLoginPageState extends State<SingpassLoginPage> {
  // 登录状态
  bool _isLoading = false;
  String? _errorMessage;

  /// 处理 Singpass 登录
  void _handleSingpassLogin() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 获取 Singpass 认证 URL
      final authUrl = SingpassService.login();

      // 使用 url_launcher 打开 Singpass 认证页面（会自动使用 In-App Browsers）
      _launchSingpassAuthUrl(authUrl);
    } catch (e) {
      // 捕获异常，显示错误信息
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
    }
  }

  /// 使用 url_launcher 打开 Singpass 认证 URL
  Future<void> _launchSingpassAuthUrl(String authUrl) async {
    final uri = Uri.parse(authUrl);

    if (await canLaunchUrl(uri)) {
      // 使用系统默认浏览器或 In-App Browsers 打开认证 URL
      // url_launcher 会自动处理：iOS 会使用 SFSafariViewController，Android 会使用 Custom Tabs
      // 这符合 Singpass v5 不再支持 WebView 的要求
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not launch Singpass authentication page.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login with Singpass'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo 或标题部分
              _buildHeaderSection(),

              SizedBox(height: 48.h),

              // 错误信息显示
              if (_errorMessage != null) _buildErrorSection(),

              SizedBox(height: 24.h),

              // Singpass 登录按钮
              _buildSingpassLoginButton(),

              SizedBox(height: 24.h),

              // 其他登录选项或说明
              _buildAdditionalOptions(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建页面头部
  Widget _buildHeaderSection() {
    return Column(
      children: [
        // 可以替换为您的应用 Logo
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Center(
            child: Text(
              'App Logo',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A73E8),
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Welcome to Your App',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          'Login with your Singpass to continue',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 构建错误信息显示区域
  Widget _buildErrorSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFD32F2F),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建 Singpass 登录按钮
  Widget _buildSingpassLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSingpassLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 0,
        minimumSize: Size(double.infinity, 56.h),
      ),
      child:
          _isLoading ? _buildLoadingIndicator() : _buildSingpassButtonContent(),
    );
  }

  /// 构建加载指示器
  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 24.w,
      height: 24.w,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2.w,
      ),
    );
  }

  /// 构建 Singpass 按钮内容
  Widget _buildSingpassButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Singpass Logo 可以替换为实际的 Singpass Logo
        Container(
          width: 24.w,
          height: 24.w,
          margin: EdgeInsets.only(right: 12.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(
                color: Color(0xFF007AFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(
          'Login with Singpass',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// 构建其他选项或说明
  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        Text(
          'By logging in, you agree to our Terms of Service and Privacy Policy',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                // 跳转到注册页面或显示注册选项
                Get.toNamed('/register');
              },
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF007AFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
