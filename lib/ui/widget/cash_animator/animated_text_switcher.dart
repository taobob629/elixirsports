import 'package:elixir_esports/ui/widget/cash_animator/switcher_widget.dart';
import 'package:flutter/material.dart';

class AnimatedTextSwitcher extends StatefulWidget {
  /// The text to display.
  final String text;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// How visual overflow should be handled.
  ///
  /// If this is null [TextStyle.overflow] will be used, otherwise the value
  /// from the nearest [DefaultTextStyle] ancestor will be used.
  final TextOverflow? overflow;

  /// Duration of all transitions
  final Duration? duration;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;

  const AnimatedTextSwitcher(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.duration,
  });

  @override
  State<AnimatedTextSwitcher> createState() => _AnimatedTextSwitcherState();
}

class _AnimatedTextSwitcherState extends State<AnimatedTextSwitcher>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 300);
  late final _controller =
      AnimationController(vsync: this, duration: widget.duration ?? _duration);
  late String _oldText = widget.text;
  late String _newText = widget.text;

  @override
  void didUpdateWidget(covariant AnimatedTextSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldText = oldWidget.text;
    _newText = widget.text;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwitcherWidget(
      controllers: [_controller],
      newChars: [_newText],
      oldChars: [_oldText],
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
