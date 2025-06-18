import 'package:elixir_esports/assets_utils.dart';
import 'package:elixir_esports/base/base_scaffold.dart';
import 'package:elixir_esports/base/empty_view.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/ui/widget/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/bank_cards_ctr.dart';
import '../../../utils/color_utils.dart';

class BankCardsPage extends BasePage<BankCardsCtr> {

  @override
  BankCardsCtr createController() => BankCardsCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Bank Cards".tr,
        body: Obx(() => controller.showLoading.value
            ? Container()
            : Column(
                children: [
                  controller.bankCardList.isNotEmpty
                      ? Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (c, i) => itemWidget(i),
                            separatorBuilder: (c, i) => 15.verticalSpace,
                            itemCount: controller.bankCardList.length,
                          ),
                        )
                      : SizedBox(height: 0.5.sh, child: EmptyView()),
                  40.verticalSpace,
                  Visibility(
                    visible: controller.bankCardList.isNotEmpty &&
                        controller.showSelectStatus,
                    child: MyButtonWidget(
                      btnText: 'CONFIRM'.tr,
                      marginLeft: 15.w,
                      marginRight: 15.w,
                      marginBottom: 20.h,
                      onTap: () => Get.back(
                          result: controller.bankCardList[
                              controller.currentSelectIndex.value]),
                    ),
                  ),
                  MyButtonWidget(
                    btnText: 'ADD BANK CARD'.tr,
                    marginLeft: 15.w,
                    marginRight: 15.w,
                    onTap: controller.addBankCards,
                  ),
                ],
              ).marginAll(15.r)),
      );

  Widget itemWidget(int i) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => controller.currentSelectIndex.value = i,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Row(
            children: [
              10.horizontalSpace,
              Visibility(
                visible: controller.showSelectStatus,
                child: Obx(() => controller.currentSelectIndex.value == i
                    ? Icon(
                        Icons.check_circle,
                        size: 24.sp,
                        color: Colors.blue,
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        size: 24.sp,
                      )),
              ),
              SvgPicture.asset(
                AssetsUtils.bank_card_list_icon,
                height: 60.h,
              ),
              Expanded(
                child: Text(
                  controller.bankCardList[i].cardNo.toString().length <= 4
                      ? '**** **** **** ****'
                      : '**** **** **** ${controller.bankCardList[i].cardNo.toString().substring(controller.bankCardList[i].cardNo.toString().length - 4)}',
                  style: TextStyle(
                    color: toColor("3d3d3d"),
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ),
              InkWell(
                onTap: () => controller.deleteBankCard(i),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Text(
                    "Delete".tr,
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: FONT_MEDIUM,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
