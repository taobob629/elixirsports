import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/top_up_ctr.dart';
import '../../widget/my_button_widget.dart';

class TopUpPage extends BasePage<TopUpCtr> {

  @override
  TopUpCtr createController() => TopUpCtr();

  @override
  Widget buildBody(BuildContext context) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: BaseScaffold(
          title: "TOP UP".tr,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  width: 1.sw,
                  margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  padding: EdgeInsets.fromLTRB(15.w, 26.h, 15.w, 75.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TOP UP".tr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                          color: toColor('#3d3d3d'),
                        ),
                      ),
                      Container(
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: toColor('#F4FAFA'),
                          border: Border.all(color: Colors.black, width: 1.5.w),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        margin: EdgeInsets.only(top: 20.h, bottom: 15.h),
                        child: Container(
                          height: 44.h,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 8.w),
                          child: TextField(
                            controller: controller.inputMoneyCtr,
                            focusNode: controller.inputMoneyFocusNode,
                            keyboardType: TextInputType.number,
                            // 设置键盘类型为数字
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                            ],
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              isCollapsed: true,
                              hintText: 'Please Enter The Amount'.tr,
                              hintStyle: TextStyle(
                                color: toColor('#A2A2A2'),
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ).paddingOnly(left: 4.w),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 15.r,
                          crossAxisSpacing: 15.r,
                          childAspectRatio: 95.w / 55.w,
                        ),
                        itemBuilder: (context, index) => Obx(() => InkWell(
                              onTap: () =>
                                  controller.currentIndex.value = index,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.currentIndex.value ==
                                          index
                                      ? toColor('#18CBE6')
                                      : toColor('#F4FAFA'),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "S\$${controller.moneyList[index]}",
                                  style: TextStyle(
                                    color: controller.currentIndex.value ==
                                            index
                                        ? Colors.white
                                        : toColor('333333'),
                                    fontFamily: FONT_MEDIUM,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            )),
                        itemCount: controller.moneyList.length,
                      ),
                      MyButtonWidget(
                        btnText: "CONFIRM".tr,
                        marginTop: 45.h,
                        onTap: () => controller.confirm(),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingOnly(bottom: 15.h),
          ),
        ),
      );
}
