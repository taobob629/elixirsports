import 'package:elixir_esports/config/icon_font.dart';
import 'package:elixir_esports/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../utils/system_utils.dart';
import '../../utils/toast_utils.dart';

class DatePickerWidget extends StatelessWidget {

  var currentHour = 0.obs;
  var currentMin = 0.obs;
  late DateTime selectDate;
  String? initDateStr;

  DatePickerWidget({
    this.initDateStr,
  });

  @override
  Widget build(BuildContext context) {
    SystemUtils.hiddenSoftKeyboard();
    DateTime nowTime = DateTime.now();

    if (initDateStr != null) {
      selectDate = DateTime.parse(initDateStr!);
    } else {
      selectDate = nowTime;
    }
    currentHour.value = selectDate.hour;
    currentMin.value = selectDate.minute;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      width: 0.9.sw,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SfDateRangePicker(
            showNavigationArrow: true,
            initialSelectedDate: selectDate,
            headerStyle: DateRangePickerHeaderStyle(
              textStyle: TextStyle(
                fontSize: 18.sp,
                color: toColor('3d3d3d'),
                fontFamily: FONT_MEDIUM,
              ),
            ),
            selectionColor: Colors.blue,
            monthCellStyle: DateRangePickerMonthCellStyle(
              todayTextStyle: TextStyle(
                color: toColor('3d3d3d'),
                fontSize: 18.sp,
              ),
              textStyle: TextStyle(
                color: toColor('3d3d3d'),
                fontSize: 18.sp,
              ),
            ),
            selectionTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            onSelectionChanged: (DateRangePickerSelectionChangedArgs value) =>
                selectDate = value.value as DateTime,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => dismissLoading(),
                child: Text(
                  "Cancel".tr,
                  style: TextStyle(
                    color: toColor('3d3d3d'),
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => dismissLoading(result: selectDate),
                child: Text(
                  "OK".tr,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
