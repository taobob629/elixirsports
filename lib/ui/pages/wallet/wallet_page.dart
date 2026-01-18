import 'package:elixir_esports/models/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../assets_utils.dart';
import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../base/empty_view.dart';
import '../../../getx_ctr/user_controller.dart';
import '../../../getx_ctr/wallet_ctr.dart';
import '../../widget/animated_value_widget.dart';
import '../../widget/cash_animator/animated_text_switcher.dart';

class WalletPage extends BasePage<WalletCtr> {
  @override
  WalletCtr createController() => WalletCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Wallet".tr,
        body: Obx(() => controller.showLoading.value
            ? Container()
            : Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [toColor('#FD804F'), toColor('#FCA92D')],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetsUtils.icon_cash,
                              height: 14.w,
                            ),
                            Expanded(
                              child: Text(
                                'Elixir Wallet'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                              ).paddingOnly(left: 4.w),
                            ),
                            SvgPicture.asset(
                              AssetsUtils.icon_reward,
                              height: 14.w,
                            ),
                            Text(
                              'Reward Wallet'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ).paddingOnly(left: 4.w),
                          ],
                        ).marginOnly(top: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => Align(
                                    alignment: Alignment.centerLeft,
                                    child: AnimatedValueWidget(
                                      oldValue:
                                          controller.oldWalletModel.value.cash,
                                      newValue:
                                          controller.walletModel.value.cash,
                                      showAnimation:
                                          controller.showAnimator.value,
                                      currencySymbol: 'S\$',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.sp,
                                        fontFamily: FONT_MEDIUM,
                                      ),
                                    ).paddingOnly(left: 4.w),
                                  )),
                            ),
                            Obx(() => Align(
                                  alignment: Alignment.centerLeft,
                                  child: AnimatedValueWidget(
                                    oldValue:
                                        controller.oldWalletModel.value.reward,
                                    newValue:
                                        controller.walletModel.value.reward,
                                    showAnimation:
                                        controller.showAnimator.value,
                                    currencySymbol: 'S\$',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.sp,
                                      fontFamily: FONT_MEDIUM,
                                    ),
                                  ).paddingOnly(left: 4.w),
                                )),
                          ],
                        ).marginOnly(top: 18.h),
                        InkWell(
                          onTap: controller.topUp,
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              color: UserController
                                          .find.profileModel.value.topup ==
                                      true
                                  ? Colors.white
                                  : Colors.grey[400],
                            ),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              top: 20.h,
                              bottom: 10.h,
                            ),
                            child: Text(
                              "TOP-UP".tr,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                color: UserController
                                            .find.profileModel.value.topup ==
                                        true
                                    ? toColor('#3D3D3D')
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 15.w),
                      padding: EdgeInsets.all(15.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRANSACTION DETAILS'.tr,
                            style: TextStyle(
                              color: toColor('#1A1A1A'),
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                          Divider(
                            color: toColor('EEEEEE'),
                            height: 1.h,
                          ).marginOnly(top: 15.h),
                          Expanded(
                            child: Obx(() => controller.list.isNotEmpty
                                ? _buildSmartRefresher()
                                : EmptyView()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(bottom: 15.h)),
      );

  Widget _buildSmartRefresher() {
    final RefreshController refreshController =
        RefreshController(initialRefresh: false);
    return SmartRefresher(
      controller: refreshController,
      onRefresh: () async {
        await controller.onRefresh();
        refreshController.refreshCompleted();
      },
      onLoading: () async {
        await controller.loadMore();
        refreshController.loadComplete();
      },
      enablePullUp: true,
      enablePullDown: true,
      child: ListView.separated(
        itemBuilder: (c, i) => itemWidget(controller.list[i]),
        separatorBuilder: (c, i) => Divider(
          color: toColor("EEEEEE"),
          height: 1.h,
        ),
        itemCount: controller.list.length,
      ),
    );
  }

  Widget itemWidget(WalletRow model) => Column(
        children: [
          Row(
            children: [
              Text(
                model.name ?? '',
                style: TextStyle(
                  color: toColor('#3D3D3D'),
                  fontSize: 14.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
            ],
          ).paddingOnly(top: 15.h, bottom: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Elixirs：'.tr,
                style: TextStyle(
                  color: toColor('#767676'),
                  fontSize: 13.sp,
                  fontFamily: FONT_MEDIUM,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${model.unit}${model.money}",
                style: TextStyle(
                  color: model.color == 1
                      ? toColor('#EA0000')
                      : toColor('#25AF23'),
                  fontSize: 13.sp,
                  fontFamily: FONT_MEDIUM,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ).paddingOnly(bottom: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reward：'.tr,
                style: TextStyle(
                  color: toColor('#767676'),
                  fontSize: 13.sp,
                  fontFamily: FONT_MEDIUM,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${model.unit}${model.reward}",
                style: TextStyle(
                  color: model.color == 1
                      ? toColor('#EA0000')
                      : toColor('#25AF23'),
                  fontSize: 13.sp,
                  fontFamily: FONT_MEDIUM,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ).paddingOnly(bottom: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.time ?? '',
                style: TextStyle(
                  color: toColor('#767676'),
                  fontSize: 12.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              Text(
                model.payWay ?? '',
                style: TextStyle(
                  color: toColor('#010101'),
                  fontSize: 12.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
            ],
          ).paddingOnly(bottom: 15.h),
        ],
      );
}
