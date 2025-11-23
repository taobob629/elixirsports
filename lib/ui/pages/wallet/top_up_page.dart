import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../../utils/toast_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/top_up_ctr.dart';
import '../../widget/my_button_widget.dart';

// 修正：移除了构造函数前的 const 关键字
class TopUpPage extends BasePage<TopUpCtr> {
  final String? message;

  // 构造函数不再是 const
  TopUpPage({
    this.message,
  });

  @override
  TopUpCtr createController() => TopUpCtr();

  @override
  Widget buildBody(BuildContext context) => _TopUpPageBody(
    message: message,
    controller: createController(),
  );
}

class _TopUpPageBody extends StatefulWidget {
  final String? message;
  final TopUpCtr controller;

  const _TopUpPageBody({
    required this.controller,
    this.message,
  });

  @override
  State<_TopUpPageBody> createState() => _TopUpPageBodyState();
}

class _TopUpPageBodyState extends State<_TopUpPageBody> {
  @override
  void initState() {
    super.initState();
    if (widget.message?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showToast(widget.message!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(widget.controller);

    return KeyboardDismissOnTap(
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
                          controller: widget.controller.inputMoneyCtr,
                          focusNode: widget.controller.inputMoneyFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
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
                        onTap: () {
                          widget.controller.currentIndex.value = index;
                          widget.controller.inputMoneyCtr.text = widget.controller.moneyList[index].toString();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.controller.currentIndex.value == index ? toColor('#18CBE6') : toColor('#F4FAFA'),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "S\$${widget.controller.moneyList[index]}",
                            style: TextStyle(
                              color: widget.controller.currentIndex.value == index ? Colors.white : toColor('333333'),
                              fontFamily: FONT_MEDIUM,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      )),
                      itemCount: widget.controller.moneyList.length,
                    ),
                    MyButtonWidget(
                      btnText: "CONFIRM".tr,
                      marginTop: 45.h,
                      onTap: () => widget.controller.confirm(),
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
}