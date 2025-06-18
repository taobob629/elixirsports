/*
  Translations
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:ui';

import 'package:elixir_esports/lang/zh_CN.dart';
import 'package:get/get.dart';

import 'en_US.dart';

const CHINA = Locale('zh', 'CN');
const ENGLISH = Locale('en', 'US');
var languages = [CHINA, ENGLISH];

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'zh_CN': zh_CN,
      };
}
