import 'package:elixir_esports/base/base_scaffold.dart';
import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/add_bank_cards_ctr.dart';
import '../../widget/my_button_widget.dart';

class AddBankCardsPage extends BasePage<AddBankCardsCtr> {

  @override
  AddBankCardsCtr createController() => AddBankCardsCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: 'ADD BANK CARD'.tr,
        body: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 20.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "*",
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                    children: [
                      TextSpan(
                        text: "Card Number".tr,
                        style: TextStyle(
                          color: toColor('#1A1A1A'),
                          fontFamily: FONT_MEDIUM,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                ),
                Obx(() => commonTextField(
                      isShowRedBorder: controller.isRightCardNo.value,
                      inputFormatters: [controller.cardNoFormatter],
                      onChanged: (String value) =>
                          controller.validateCardNo(value),
                      hintText: "0000-0000-0000-0000",
                      keyboardType: TextInputType.number,
                    )),
                RichText(
                  text: TextSpan(
                    text: "*",
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                    children: [
                      TextSpan(
                        text: "Expiry Date".tr,
                        style: TextStyle(
                          color: toColor('#1A1A1A'),
                          fontFamily: FONT_MEDIUM,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                ),
                Obx(() => commonTextField(
                      isShowRedBorder: controller.isRightDate.value,
                      inputFormatters: [controller.dateFormatter],
                      onChanged: (String value) =>
                          controller.validateDate(value),
                      hintText: "MM/YYYY",
                      keyboardType: TextInputType.number,
                    )),
                RichText(
                  text: TextSpan(
                    text: "*",
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                    children: [
                      TextSpan(
                        text: "CVV/CVV2".tr,
                        style: TextStyle(
                          color: toColor('#1A1A1A'),
                          fontFamily: FONT_MEDIUM,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                ),
                Obx(() => commonTextField(
                      controller: controller.cvvCtr,
                      isShowRedBorder: controller.isHaveCvv.value,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (String value) =>
                          controller.isHaveCvv.value = value.length > 2,
                      hintText: "***",
                      keyboardType: TextInputType.number,
                    )),
                Text(
                  "CardHolder Name".tr,
                  style: TextStyle(
                    color: toColor('#1A1A1A'),
                    fontFamily: FONT_MEDIUM,
                    fontSize: 14.sp,
                  ),
                ),
                commonTextField(
                  controller: controller.nameCtr,
                  isShowRedBorder: true,
                  hintText: "CardHolder Name".tr,
                ),
                Text(
                  "Email Address".tr,
                  style: TextStyle(
                    color: toColor('#1A1A1A'),
                    fontFamily: FONT_MEDIUM,
                    fontSize: 14.sp,
                  ),
                ),
                commonTextField(
                  controller: controller.emailCtr,
                  isShowRedBorder: true,
                  hintText: "Email Address".tr,
                ),
                MyButtonWidget(
                  btnText: "SAVE".tr,
                  marginBottom: 10.h,
                  onTap: controller.payment,
                ),
              ],
            ),
          ),
        ),
      );

  Widget commonTextField({
    required bool isShowRedBorder,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
    String? hintText,
    TextInputType? keyboardType,
  }) =>
      Container(
        height: 44.h,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 15.h, bottom: 20.h),
        decoration: BoxDecoration(
          color: toColor('#ECF1FA'),
          borderRadius: BorderRadius.circular(8.r),
          border: isShowRedBorder
              ? null
              : Border.all(
                  color: Colors.red,
                  width: 1.w,
                ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: (String value) => onChanged?.call(value),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            isCollapsed: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: toColor('#A2A2A2'),
              fontSize: 14.sp,
            ),
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
          ),
        ),
      );
}
