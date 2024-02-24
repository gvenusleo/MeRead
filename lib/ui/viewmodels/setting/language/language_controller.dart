import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/common/global.dart';
import 'package:meread/common/helpers/prefs_helper.dart';

class LanguageController extends GetxController {
  RxString language = PrefsHelper.language.obs;

  Future<void> updateLanguage(String value) async {
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
    await PrefsHelper.updateLanguage(value);
    logger.i('[Setting] 切换语言: $value');
  }
}
