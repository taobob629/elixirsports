import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/contact_us_ctr.dart';
import '../../../models/problem_model.dart';

class ContactUsPage extends BasePage<ContactUsCtr> {
  @override
  ContactUsCtr createController() => ContactUsCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Contact us".tr,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 300.w,
              margin: EdgeInsets.only(top: 15.h, left: 15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                children: [
                  Container(
                    width: 300.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.r),
                        topLeft: Radius.circular(15.r),
                      ),
                      gradient: LinearGradient(
                        colors: [toColor('#EEEEEE'), toColor('#BCFFFD')],
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15.w),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "FAQ".tr,
                      style: TextStyle(
                        color: toColor('#196A68'),
                        fontFamily: FONT_MEDIUM,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  ...controller.list
                      .map((e) => Column(
                            children: [
                              InkWell(
                                onTap: () => controller.getProblemsAnswer(e),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        e.name ?? '',
                                        style: TextStyle(
                                          color: toColor('#3D3D3D'),
                                          fontFamily: FONT_LIGHT,
                                          fontSize: 13.sp,
                                        ),
                                      ).marginAll(15.r),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: toColor('#42494F'),
                                      size: 18.sp,
                                    ),
                                  ],
                                ).paddingOnly(right: 15.w),
                              ),
                              Divider(
                                color: toColor("EEEEEE"),
                                height: 1.h,
                              )
                            ],
                          ))
                      .toList(),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.separated(
                    controller: controller.scrollController,
                    itemBuilder: (BuildContext context, int index) =>
                        itemWidget(controller.selectProblemList[index]),
                    separatorBuilder: (BuildContext context, int index) =>
                        15.verticalSpace,
                    itemCount: controller.selectProblemList.length,
                  )),
            ),
          ],
        ).paddingOnly(bottom: 15.h),
      );

  Widget itemWidget(ProblemModel model) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 15.h,
              left: 60.w,
              right: 15.w,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15.r),
            ),
            padding: EdgeInsets.all(15.r),
            child: Text(
              model.name ?? '',
              style: TextStyle(
                color: toColor('#ffffff'),
                fontSize: 16.sp,
                fontFamily: FONT_LIGHT,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Visibility(
              visible: model.content != null,
              child: Container(
                width: 300.w,
                margin: EdgeInsets.only(
                  top: 15.h,
                  left: 60.w,
                  right: 15.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                padding: EdgeInsets.all(15.r),
                child: Text(
                  model.content ?? '',
                  style: TextStyle(
                    color: toColor('#3D3D3D'),
                    fontSize: 16.sp,
                    fontFamily: FONT_LIGHT,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
