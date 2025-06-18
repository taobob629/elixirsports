import 'package:flutter/material.dart';

class SwitcherWidget extends StatelessWidget {
  final List<String> newChars;
  final List<String> oldChars;
  final List<AnimationController> controllers;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  const SwitcherWidget({
    super.key,
    required this.controllers,
    required this.newChars,
    required this.oldChars,
    required this.style,
    required this.textAlign,
    required this.maxLines,
    required this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: List.generate(
              oldChars.length,
              (index) {
                final controller = controllers.elementAtOrNull(index);
                if (controller == null) return const SizedBox();
                return FadeTransition(
                  opacity: CurvedAnimation(
                          parent: controller, curve: Curves.easeOutQuint)
                      .drive(Tween(begin: 1, end: 0)),
                  child: SlideTransition(
                    position:
                        CurvedAnimation(parent: controller, curve: Curves.ease)
                            .drive(
                      Tween(begin: const Offset(0, 0), end: const Offset(0, 1)),
                    ),
                    child: Text(
                      oldChars[index],
                      style: style,
                      overflow: overflow,
                      textAlign: textAlign,
                      maxLines: maxLines,
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: List.generate(
              newChars.length,
              (index) {
                final controller = controllers.elementAtOrNull(index);
                if (controller == null) return const SizedBox();
                return FadeTransition(
                  opacity:
                      CurvedAnimation(parent: controller, curve: Curves.ease)
                          .drive(Tween(begin: 0, end: 1)),
                  child: SlideTransition(
                    position:
                        CurvedAnimation(parent: controller, curve: Curves.ease)
                            .drive(
                      Tween(
                          begin: const Offset(0, -1), end: const Offset(0, 0)),
                    ),
                    child: Text(
                      newChars[index],
                      style: style,
                      overflow: overflow,
                      textAlign: textAlign,
                      maxLines: maxLines,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
