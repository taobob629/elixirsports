import 'package:flutter/material.dart';
import 'package:elixir_esports/models/order_model.dart';
import 'pay_order_page.dart';

class LoginConfirmPage extends StatefulWidget {
  final String loginTips; // 登录提示文案
  final OrderData orderData; // 订单数据（用于跳转到支付页）

  const LoginConfirmPage({
    super.key,
    required this.loginTips,
    required this.orderData,
  });

  @override
  State<LoginConfirmPage> createState() => _LoginConfirmPageState();
}

class _LoginConfirmPageState extends State<LoginConfirmPage> {
  // 模拟登录接口（你可替换为实际登录逻辑）
  Future<void> _doLogin() async {
    // 这里可调用实际登录接口，比如获取token/验证用户态
    await Future.delayed(const Duration(milliseconds: 500)); // 模拟接口延迟

    // 登录成功后询问是否进入支付页
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登录成功'),
        content: const Text('是否进入支付页面？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 跳转到支付页面
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PayOrderPage(orderData: widget.orderData),
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 取消登录
  void _cancelLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('取消登录'),
        content: const Text('确定要取消登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 取消后可返回上一页/关闭页面
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已取消登录，页面将关闭')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Center(
        // 修复点：移除maxWidth，改用ConstrainedBox限制最大宽度
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420, // 这里用ConstrainedBox实现maxWidth效果
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 登录图标
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xffe8f4f8),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.login,
                    size: 40,
                    color: Color(0xff1890ff),
                  ),
                ),
                // 标题
                const Text(
                  '登录确认',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333),
                  ),
                ),
                // 提示文案
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text(
                    widget.loginTips,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff666666),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // 登录按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1890ff),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _doLogin,
                    child: const Text(
                      '完成登录',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // 取消按钮
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Color(0xffe0e0e0)),
                    ),
                    onPressed: _cancelLogin,
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff333333),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}