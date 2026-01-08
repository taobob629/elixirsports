import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:elixir_esports/models/order_model.dart';
import 'login_confirm_page.dart';
import 'pay_order_page.dart';

class ScanOrderEntryPage extends StatefulWidget {
  const ScanOrderEntryPage({super.key});

  @override
  State<ScanOrderEntryPage> createState() => _ScanOrderEntryPageState();
}

class _ScanOrderEntryPageState extends State<ScanOrderEntryPage> {
  bool _isLoading = true;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    // 页面加载时请求订单接口
    _fetchOrderData();
  }

  // 请求订单接口
  Future<void> _fetchOrderData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMsg = '';
      });

      // 替换为你的实际接口地址（注意处理跨域/HTTPS）
      final response = await http.get(
        Uri.parse('https://your-domain.com/appPayOrder'),
        // 可添加请求头，比如token
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${yourToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        OrderResponse orderResponse = OrderResponse.fromJson(jsonData);

        if (orderResponse.code == 200 && orderResponse.data != null) {
          // 根据是否需要登录，跳转对应页面
          if (orderResponse.data!.needLogin) {
            // 跳转到登录确认页
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginConfirmPage(
                  loginTips: orderResponse.data!.loginTips,
                  orderData: orderResponse.data!,
                ),
              ),
            );
          } else {
            // 直接跳转到支付页
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PayOrderPage(orderData: orderResponse.data!),
              ),
            );
          }
        } else {
          setState(() {
            _errorMsg = orderResponse.msg;
          });
        }
      } else {
        setState(() {
          _errorMsg = '接口请求失败：${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMsg = '网络异常：$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Color(0xff1890ff))
            : _errorMsg.isNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMsg,
              style: const TextStyle(color: Color(0xffff4d4f), fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchOrderData,
              child: const Text('重新加载'),
            ),
          ],
        )
            : const SizedBox(),
      ),
    );
  }
}