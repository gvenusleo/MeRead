import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/helpers/prefs_helper.dart';

class LanguageController extends GetxController {
  RxString language = PrefsHelper.language.obs;

  void updateLanguage(String value) {
    if (language.value == value) return;
    language.value = value;
    Get.updateLocale(
      {
            'system': Get.deviceLocale ?? const Locale('zh', 'US'),
            'zh_CN': const Locale('zh', 'CN'),
            'en_US': const Locale('en', 'US'),
          }[value] ??
          Get.deviceLocale ??
          const Locale('en', 'US'),
    );
    PrefsHelper.language = value;
    LogHelper.i('[Setting] Change language to: $value');
  }
}
