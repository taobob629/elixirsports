/**
    author:mac
    创建日期:2023/2/10
    描述:
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elixir_esports/assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageUtil {
  ImageUtil._();

  static Widget lowMemoryNetworkImage({
    required String url,
    double? width,
    double? height,
    double border = 0,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = true,
    bool lowMemory = true,
    Widget? errorWidget,
  }) =>
      _cachedNetworkImage(
        url: url,
        width: width,
        height: height,
        border: border,
        cacheWidth: cacheHeight,
        cacheHeight: cacheHeight,
        fit: fit,
        loadProgress: loadProgress,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        lowMemory: lowMemory,
        errorWidget: errorWidget,
      );

  static Widget networkImage({
    required String url,
    double? width,
    double? height,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    double border = 0,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = false,
    bool lowMemory = true,
    Widget? errorWidget,
  }) =>
      lowMemoryNetworkImage(
        url: url,
        width: width,
        border: border,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        fit: fit,
        loadProgress: loadProgress,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        lowMemory: lowMemory,
        errorWidget: errorWidget,
      );

  static Widget _cachedNetworkImage({
    required String url,
    double? width,
    double? height,
    double border = 0,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = true,
    bool lowMemory = true,
    Widget? errorWidget,
  }) {
    // 修复 url 为 null 或空字符串时的错误
    if (url == null || url.isEmpty) {
      return errorWidget ?? error(width: width, height: height);
    }
    
    return border == 0
        ? CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: fit,
            progressIndicatorBuilder: (context, url, progress) => Container(
              width: 10.0,
              height: 10.0,
              child: loadProgress
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        value: progress.progress ?? 0,
                      ),
                    )
                  : null,
            ),
            errorWidget: (_, url, er) =>
                errorWidget ?? error(width: width, height: height),
          )
        : Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(border)),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: url,
              width: width,
              height: height,
              fit: fit,
              progressIndicatorBuilder: (context, url, progress) => Container(
                width: 10.0,
                height: 10.0,
                child: loadProgress
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          value: progress.progress ?? 0,
                        ),
                      )
                    : null,
              ),
              errorWidget: (_, url, er) =>
                  errorWidget ?? error(width: width, height: height),
            ),
          );
  }

  static Widget error({
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) =>
      Image.asset(
        AssetsUtils.home_logo_icon,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
}
