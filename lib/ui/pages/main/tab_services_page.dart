import 'package:elixir_esports/ui/pages/main/service/book_widget.dart';
import 'package:elixir_esports/ui/pages/main/service/no_book_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/base_page.dart';
import '../../../getx_ctr/service_ctr.dart';

class TabServicesPage extends BasePage<ServiceCtr> {

  @override
  ServiceCtr createController() => ServiceCtr();

  @override
  Widget buildBody(BuildContext context) => SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Obx(() => controller.bookingDetailModel.value.id != null
            ? BookWidget()
            : NoBookWidget()),
      );
}
