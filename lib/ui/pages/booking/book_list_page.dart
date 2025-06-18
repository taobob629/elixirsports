import 'package:elixir_esports/models/booking_list_model.dart';
import 'package:elixir_esports/utils/decimal_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/color_utils.dart';
import '../../../base/base_page.dart';
import '../../../base/base_scaffold.dart';
import '../../../getx_ctr/book_list_ctr.dart';
import 'book_detail_page.dart';

class BookListPage extends BasePage<BookListCtr> {
  @override
  BookListCtr createController() => BookListCtr();

  @override
  Widget buildBody(BuildContext context) => BaseScaffold(
        title: "Booking".tr,
        body: Obx(() => ListView.separated(
              itemBuilder: (c, i) => itemWidget(controller.rowList[i]),
              separatorBuilder: (c, i) => 10.verticalSpace,
              itemCount: controller.rowList.length ?? 0,
            ).marginOnly(top: 15.h)),
      );

  Widget itemWidget(BookingRow bookingRow) => Container(
        decoration: BoxDecoration(
            color: toColor('#F3FCFA'),
            borderRadius: BorderRadius.circular(5.2.r),
            border: Border.all(color: toColor('#CEE5E0'), width: 1.w)),
        padding: EdgeInsets.all(15.r),
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bookingRow.storeName ?? '',
                  style: TextStyle(
                    color: toColor('#3D3D3D'),
                    fontFamily: FONT_LIGHT,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: toColor('#CAFFCB'),
                    borderRadius: BorderRadius.circular(1.5.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.5.h,
                  ),
                  child: Text(
                    bookingRow.status == 0
                        ? "Ongoing".tr
                        : bookingRow.status == 1
                            ? "Canceled".tr
                            : "Completed".tr,
                    style: TextStyle(
                      color: toColor('#20721C'),
                      fontFamily: FONT_LIGHT,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            orderingInfoWidget("Number of seats".tr,
                controller.calNumberOfSeat(bookingRow.computers)),
            orderingInfoWidget(
                "Payment".tr,
                ((double.parse(bookingRow.balance.add(bookingRow.points))) /
                        100)
                    .toStringAsFixed(2)),
            orderingInfoWidget("Reservation code".tr, "${bookingRow.code}"),
            Divider(
              color: toColor('EEEEEE'),
              height: 1.h,
            ).marginOnly(bottom: 15.h),
            InkWell(
              onTap: () => controller.jumpDetail(bookingRow.id),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${bookingRow.bookingTime}",
                      style: TextStyle(
                        color: toColor('#767676'),
                        fontSize: 12.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ),
                  Text(
                    "View details".tr,
                    style: TextStyle(
                      color: toColor('#1A1A1A'),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ).paddingOnly(right: 8.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: toColor('#42494F'),
                    size: 16.sp,
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget orderingInfoWidget(String name, String value) => Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: toColor('#767676'),
                fontSize: 12.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: toColor('#1A1A1A'),
              fontSize: 12.sp,
              fontFamily: FONT_MEDIUM,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ).paddingSymmetric(vertical: 15.h);
}
