import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/base/empty_view.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/getx_ctr/main_ctr.dart';
import 'package:elixir_esports/getx_ctr/user_controller.dart';
import 'package:elixir_esports/ui/pages/main/scan/my_qr_code_page.dart';
import 'package:elixir_esports/ui/pages/store/select_store_page.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:elixir_esports/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/home_page_ctr.dart';
import '../../../models/store_model.dart';
import '../../../utils/toast_utils.dart';
import '../../dialog/switch_language_dialog.dart';
import '../../widget/search_widget.dart';
import '../booking/book_seat_page.dart';

class TabHomePage extends BasePage<HomePageCtr> {

  @override
  HomePageCtr createController() => HomePageCtr();

  @override
  Widget buildBody(BuildContext context) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 365.h,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 1.sw,
                      height: 280.h,
                      child: SvgPicture.asset(
                        AssetsUtils.home_top_bg,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 15.w,
                      top: 55.h,
                      child: Image.asset(
                        AssetsUtils.home_logo_icon,
                        width: 106.w,
                      ),
                    ),
                    Positioned(
                      right: 15.w,
                      top: 64.h,
                      child: InkWell(
                        onTap: () => showCustom(
                          SwitchLanguageDialog(),
                          alignment: Alignment.bottomCenter,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "English".tr,
                              style: TextStyle(
                                color: toColor('#3D3D3D'),
                                fontFamily: FONT_MEDIUM,
                                fontSize: 13.sp,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down_sharp,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14.w,
                      right: 14.w,
                      top: 109.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchWidget(
                              onSearch: (value) =>
                                  controller.search(value),
                            ),
                          ),
                          11.horizontalSpace,
                          InkWell(
                            onTap: () => Get.to(() => MyQrCodePage()),
                            child: SvgPicture.asset(
                              AssetsUtils.scan_icon,
                              height: 27.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 14.w,
                      right: 14.w,
                      top: 162.h,
                      child: Container(
                        height: 204.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        padding: EdgeInsets.all(15.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BOOK A SEAT".tr,
                              style: TextStyle(
                                color: toColor('#141517'),
                                fontFamily: FONT_MEDIUM,
                                fontSize: 16.sp,
                              ),
                            ).paddingOnly(bottom: 13.h),
                            Text(
                              "STORE".tr,
                              style: TextStyle(
                                color: toColor('#3D3D3D'),
                                fontFamily: FONT_LIGHT,
                                fontSize: 13.sp,
                              ),
                            ),
                            InkWell(
                              onTap: () => Get.to(() => SelectStorePage()),
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: toColor('#ECF1FA'),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                padding:
                                    EdgeInsets.only(left: 15.w, right: 15.w),
                                margin: EdgeInsets.only(top: 8.h),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Please select a store".tr,
                                        style: TextStyle(
                                          color: toColor('#767676'),
                                          fontSize: 14.sp,
                                        ),
                                      ).paddingOnly(left: 4.w),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Get.to(() => SelectStorePage()),
                              child: Container(
                                height: 40.h,
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  color: toColor('#141517'),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                margin: EdgeInsets.only(top: 20.h),
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
                  ],
                ),
              ),
              Text(
                "STORE DISPLAY".tr,
                style: TextStyle(
                  color: toColor('#141517'),
                  fontFamily: FONT_MEDIUM,
                  fontSize: 16.sp,
                ),
              ).paddingOnly(left: 30.w, top: 15.h, bottom: 15.h),
              Expanded(
                child: Obx(() => controller.list.isNotEmpty
                    ? SmartRefresher(
                        controller: controller.refreshController,
                        onRefresh: () => controller.onRefresh(),
                        onLoading: () => controller.loadMore(),
                        enablePullUp: true,
                        enablePullDown: true,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (c, i) =>
                              itemWidget(controller.list[i]),
                          separatorBuilder: (c, i) => 15.verticalSpace,
                          itemCount: controller.list.length,
                        ),
                      )
                    : EmptyView()),
              ),
            ],
          ),
        ),
      );

  Widget itemWidget(StoreModel model) => InkWell(
        onTap: () => Get.to(() => BookSeatPage(), arguments: model),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.only(bottom: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.r),
                      topLeft: Radius.circular(16.r),
                    ),
                    child: ImageUtil.networkImage(
                      url: '${model.headImage}',
                      width: 1.sw,
                      height: 184.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 15.w,
                    top: 15.h,
                    child: SvgPicture.asset(
                      AssetsUtils.hot_label_icon,
                      height: 26.h,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${model.name}',
                    style: TextStyle(
                      color: toColor('#3D3D3D'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 16.sp,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      MainCtr.find.getDistance(model.map),
                      style: TextStyle(
                        color: toColor('#767676'),
                        fontFamily: FONT_LIGHT,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.right,
                    ).paddingOnly(right: 15.w),
                  ),
                ],
              ).paddingOnly(left: 15.w, top: 15.h),
              InkWell(
                onTap: () => UserController.find.jumpPhoneOrMap(map: model.map),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AssetsUtils.store_address_icon,
                      height: 14.h,
                    ).marginOnly(top: 2.h),
                    Expanded(
                      child: Text(
                        '${model.address}\n${model.postCode}',
                        style: TextStyle(
                          color: toColor('#3D3D3D'),
                          fontFamily: FONT_LIGHT,
                          fontSize: 12.sp,
                        ),
                      ).paddingOnly(left: 4.w),
                    ),
                  ],
                ).paddingOnly(left: 15.w, top: 10.h),
              ),
              Row(
                children: [
                  Image.asset(
                    AssetsUtils.store_time_icon,
                    height: 14.h,
                  ),
                  4.horizontalSpace,
                  Text(
                    MainCtr.find.showOpenTime(model.openTime),
                    style: TextStyle(
                      color: toColor('#3D3D3D'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ).paddingOnly(left: 15.w, top: 3.h),
            ],
          ),
        ),
      );
}
