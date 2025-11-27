import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/base/empty_view.dart';
import 'package:elixir_esports/utils/toast_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/book_seat_ctr.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/utils.dart';

class BookSeatPage extends BasePage<BookSeatCtr> {
  final GlobalKey widgetKey = GlobalKey();
  var widgetHeight = 0.0.obs;

  // 底图的原始宽高
  final double baseImageWidth = 1950;
  final double baseImageHeight = 1225;

  double scaledWidth = 0;
  double scaledHeight = 0;

  @override
  BookSeatCtr createController() => BookSeatCtr();

  void _getImageSize() {
    RenderBox renderBox = widgetKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    flog("width = ${size.width}, height = ${size.height}");

    // 获取图片宽度
    scaledWidth = size.width;
    // 根据设备高度调整底图的宽度，保持原始比例
    scaledHeight = size.width * (baseImageHeight / baseImageWidth);
    controller.loadComplete.value = true;
  }

  @override
  Widget buildBody(BuildContext context) {
    return BaseScaffold(
      title: "${controller.storeModel.name}",
      body: Obx(() => controller.pageState == 4
          ? InteractiveViewer(
              // 允许缩放
              scaleEnabled: true,
              // 最小缩放比例
              minScale: 0.5,
              // 最大缩放比例
              maxScale: 4.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 1.sh,
                  child: Stack(
                    children: [
                      ExtendedImage.network(
                        "${controller.seatModel.value.image}",
                        key: widgetKey,
                        cache: true,
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                controller.loadComplete.value = false;
                              });
                              return Container();
                            case LoadState.failed:
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                dismissLoading();
                                controller.loadComplete.value = false;
                              });
                              return EmptyView();
                            case LoadState.completed:
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                dismissLoading();
                                _getImageSize();
                              });
                              return ExtendedRawImage(
                                image: state.extendedImageInfo?.image,
                                fit: BoxFit.fill,
                              );
                          }
                        },
                      ),
                      if (controller.loadComplete.value)
                        ...controller.seatModel.value.computers.map((element) {
                          // 根据比例调整每个座位图的坐标
                          double scaledX = (double.parse(element.lefts ?? "0") / 100) * scaledWidth;
                          double scaledY = (double.parse(element.tops ?? "0") / 100) * scaledHeight;
                          return Positioned(
                            left: scaledX,
                            top: scaledY,
                            child: InkWell(
                              onTap: () => controller.selectSeat(element),
                              child: Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      controller.getSeatDirectionIcon(element),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${element.name}",
                                  style: TextStyle(
                                    color: toColor('1A1A1A'),
                                    fontSize: 10.sp,
                                    fontFamily: FONT_LIGHT,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
            )
          : Container()),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.r),
            topLeft: Radius.circular(15.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => Container(
                    height: 102.h,
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 15.w,
                      top: 15.h,
                    ),
                    child: controller.selectSeatList.isNotEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Prices".tr,
                                    style: TextStyle(
                                      color: toColor('#3D3D3D'),
                                      fontFamily: FONT_MEDIUM,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Expanded(
                                    child: Obx(() => Text(
                                          "S\$${controller.totalPrice.value}/Hrs",
                                          style: TextStyle(
                                            color: toColor('#EA0000'),
                                            fontFamily: FONT_MEDIUM,
                                            fontSize: 14.sp,
                                          ),
                                        ).paddingOnly(left: 15.w)),
                                  ),
                                  InkWell(
                                    onTap: () => controller.cancelSelectSeat(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 0.5.w,
                                        ),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      width: 60.w,
                                      height: 30.h,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "CANCEL".tr,
                                        style: TextStyle(
                                          color: toColor('#1A1A1A'),
                                          fontSize: 11.sp,
                                          fontFamily: FONT_MEDIUM,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 30.h,
                                margin: EdgeInsets.only(top: 13.h),
                                child: Obx(() => ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (c, i) => Container(
                                        decoration: BoxDecoration(
                                          color: toColor('#F4FAFA'),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 0.5.w,
                                          ),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        width: 60.w,
                                        height: 30.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "NO.${controller.selectSeatList[i].name}",
                                          style: TextStyle(
                                            color: toColor('#1A1A1A'),
                                            fontSize: 11.sp,
                                            fontFamily: FONT_MEDIUM,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      separatorBuilder: (c, i) => 12.horizontalSpace,
                                      itemCount: controller.selectSeatList.length,
                                    )),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              commonWidget(
                                name: 'enable'.tr,
                                icon: AssetsUtils.seat_white_icon,
                              ),
                              commonWidget(
                                name: 'selected'.tr,
                                icon: AssetsUtils.seat_green_icon,
                              ),
                              commonWidget(
                                name: 'used'.tr,
                                icon: AssetsUtils.seat_red_icon,
                              ),
                              commonWidget(
                                name: 'booked'.tr,
                                icon: AssetsUtils.seat_purple_icon,
                              ),
                              commonWidget(
                                name: 'disable'.tr,
                                icon: AssetsUtils.seat_gray_icon,
                              ),
                            ],
                          ),
                  )),
              InkWell(
                onTap: () => controller.bookASeat(context),
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: toColor('#141517'),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  margin: EdgeInsets.only(
                    top: 8.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "BOOK A SEAT".tr,
                    style: TextStyle(
                      color: toColor('ffffff'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonWidget({
    required String name,
    required String icon,
  }) =>
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon),
            Text(
              name,
              style: TextStyle(
                color: toColor('#767676'),
                fontSize: 11.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ],
        ),
      );
}
