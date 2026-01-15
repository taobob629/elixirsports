import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedValueWidget extends StatefulWidget {
  final String oldValue;
  final String newValue;
  final bool showAnimation;
  final String currencySymbol;
  final TextStyle style;

  const AnimatedValueWidget({
    super.key,
    required this.oldValue,
    required this.newValue,
    required this.showAnimation,
    required this.currencySymbol,
    required this.style,
  });

  @override
  State<AnimatedValueWidget> createState() => _AnimatedValueWidgetState();
}

class _AnimatedValueWidgetState extends State<AnimatedValueWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  String get _displayValue {
    return '${widget.currencySymbol}${widget.newValue}';
  }

  String get _oldDisplayValue {
    return '${widget.currencySymbol}${widget.oldValue}';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.showAnimation) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedValueWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.newValue != oldWidget.newValue && widget.showAnimation) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.oldValue == widget.newValue || !widget.showAnimation) {
      return Text(
        _displayValue,
        style: widget.style,
      );
    }

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // 旧值淡出
        FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0, 0.5),
            ).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeIn),
            ),
            child: Text(
              _oldDisplayValue,
              style: widget.style,
            ),
          ),
        ),
        // 新值淡入
        FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Text(
              _displayValue,
              style: widget.style,
            ),
          ),
        ),
      ],
    );
  }
}
