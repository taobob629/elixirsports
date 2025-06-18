import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/icon_font.dart';

class PageTitle extends StatelessWidget {

  final String title;
  final Color color;

  PageTitle({
    required this.title,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16.sp,
        fontFamily: FONT_LIGHT,
        color: color
      ),
    );
  }
}