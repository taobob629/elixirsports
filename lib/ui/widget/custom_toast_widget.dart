import 'package:elixir_esports/config/icon_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color_utils.dart';

class CustomToastWidget extends StatefulWidget {
  final String msg;

  const CustomToastWidget({required this.msg, Key? key}) : super(key: key);

  @override
  CustomToastWidgetState createState() => CustomToastWidgetState();
}

class CustomToastWidgetState extends State<CustomToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
    Future.delayed(const Duration(seconds: 2), () {
      // 修复 AnimationController 被 dispose 后调用 reverse() 的错误
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 15.h,
        ),
        margin: EdgeInsets.only(
          top: 40.h,
          left: 30.w,
          right: 30.w,
        ),
        // 顶部状态栏间距
        decoration: BoxDecoration(
          color: toColor('80B850'),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.green, width: 1.w),
        ),
        child: Text(
          widget.msg,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: FONT_MEDIUM,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
