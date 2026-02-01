import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../assets_utils.dart';
import '../../../base/base_page.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/user_controller.dart';
import '../../../getx_ctr/member_ctr.dart';
import '../../../models/profile_model.dart';
import '../../../utils/color_utils.dart';
import '../../widget/page_title.dart';

class MemberPage extends BasePage<MemberCtr> {
  @override
  MemberCtr createController() => MemberCtr();

  @override
  Widget buildBody(BuildContext context) => Obx(() => Scaffold(
        appBar: null,
        body: Container(
          width: 1.sw,
          height: 1.sh,
          color: toColor("f5f5f5"),
          child: Stack(
            children: [
              Container(
                height: 280.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [toColor('#FFECDB'), toColor('#F5F5F5')],
                  ),
                ),
                padding: EdgeInsets.only(left: 15.w, top: 55.h),
                width: 1.sw,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: toColor("3d3d3d"),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: PageTitle(
                        title: "My Elixir Card".tr,
                        color: toColor("3d3d3d"),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 45.h,
                      child: Container(
                        height: 140.h,
                        margin: EdgeInsets.fromLTRB(0.w, 0.h, 15.w, 0.h),
                        child: Swiper(
                          itemBuilder: (context, index) => Stack(
                            children: [
                              Image.asset(
                                controller.getMemberShipImg(index),
                                height: 140.h,
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                left: 106.w,
                                top: 12.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star_rate_rounded,
                                      size: 12.sp,
                                      color: UserController.find.profileModel
                                                  .value.level ==
                                              UserController.find.profileModel
                                                  .value.memberShip[index].level
                                          ? Colors.green
                                          : controller
                                              .getMemberShipTextColor(index),
                                    ),
                                    Text(
                                      UserController.find.profileModel.value
                                                  .level ==
                                              UserController.find.profileModel
                                                  .value.memberShip[index].level
                                          ? 'PURCHASED.'.tr
                                          : 'NOT PURCHASED.'.tr,
                                      style: TextStyle(
                                        color: UserController.find.profileModel
                                                    .value.level ==
                                                UserController
                                                    .find
                                                    .profileModel
                                                    .value
                                                    .memberShip[index]
                                                    .level
                                            ? Colors.green
                                            : controller
                                                .getMemberShipTextColor(index),
                                        fontFamily: FONT_MEDIUM,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                      ),
                                    ).marginOnly(left: 4.w),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 106.w,
                                right: 10.w,
                                top: 40.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      UserController.find.profileModel.value
                                              .memberShip[index].name ??
                                          '',
                                      style: TextStyle(
                                        color: controller
                                            .getMemberShipDescTextColor(index),
                                        fontFamily: FONT_MEDIUM,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Text(
                                      'Upgrade to enjoy more benefits.'.tr,
                                      style: TextStyle(
                                        color: controller
                                            .getMemberShipNameTextColor(index),
                                        fontFamily: FONT_MEDIUM,
                                        fontSize: 12.sp,
                                      ),
                                    ).marginOnly(top: 6.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          loop: false,
                          index: controller.currentIndex.value,
                          itemCount: UserController
                              .find.profileModel.value.memberShip.length,
                          viewportFraction: 0.8,
                          scale: 0.9,
                          onIndexChanged: (index) =>
                              controller.currentIndex.value = index,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                width: 1.sw,
                margin: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  top: 265.h,
                  bottom: 15.h,
                ),
                padding: EdgeInsets.all(15.r),
                child: SingleChildScrollView(
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.showNote(),
                            style: TextStyle(
                              color: toColor('#767676'),
                              fontFamily: FONT_MEDIUM,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ).paddingOnly(bottom: 19.h),
                          ...controller
                              .jsonToList()
                              .map((e) => detailWidget(model: e))
                              .toList(),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: UserController.find.profileModel.value.level !=
              UserController.find.profileModel.value
                  .memberShip[controller.currentIndex.value].level,
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20.h),
            child: GestureDetector(
              onTap: () => controller.payment(),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: UserController.find.profileModel.value.topup == true
                      ? toColor('#141517')
                      : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                margin: EdgeInsets.only(
                  bottom: 0.h,
                  left: 15.w,
                  right: 15.w,
                ),
                alignment: Alignment.center,
                child: Text(
                  "S\$${UserController.find.profileModel.value.memberShip[controller.currentIndex.value].price}",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FONT_MEDIUM,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ));

  Widget detailWidget({
    required ContentModel model,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.title,
            style: TextStyle(
              color: toColor('#3D3D3D'),
              fontSize: 13.sp,
              fontFamily: FONT_MEDIUM,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...model.description
              .map((e) => Row(
                    children: [
                      SvgPicture.asset(
                        AssetsUtils.icon_youdian,
                        height: 22.w,
                      ),
                      Expanded(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            color: toColor('#3D3D3D'),
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    ],
                  ).marginOnly(top: 10.h))
              .toList(),
          Divider(
            color: toColor('EEEEEE'),
            height: 1.h,
          ).marginOnly(top: 15.h, bottom: 18.h),
        ],
      );
}
