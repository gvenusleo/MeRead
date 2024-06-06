import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/font_helper.dart';
import 'package:meread/helpers/prefs_helper.dart';

class DisplaySettingController extends GetxController {
  RxInt themeMode = PrefsHelper.themeMode.obs;
  RxBool enableDynamicColor = PrefsHelper.useDynamicColor.obs;
  RxString globalFont = PrefsHelper.themeFont.obs;
  RxList<String> fontList = ["system"].obs;
  RxString transition = PrefsHelper.transition.obs;
  RxDouble textScaleFactor = PrefsHelper.textScaleFactor.obs;
  RxString language = PrefsHelper.language.obs;

  List<String> get languageList => [
        'system',
        'zh_CN',
        'en_US',
      ];

  void changeThemeMode(int value) {
    if (value == themeMode.value) return;
    themeMode.value = value;
    PrefsHelper.themeMode = value;
    Get.changeThemeMode([
      ThemeMode.system,
      ThemeMode.light,
      ThemeMode.dark,
    ][value]);
  }

  void changeEnableDynamicColor(bool value) {
    if (value == enableDynamicColor.value) return;
    enableDynamicColor.value = value;
    PrefsHelper.useDynamicColor = value;
    Get.forceAppUpdate();
  }

  void changeGlobalFont(String value) {
    if (value == globalFont.value) return;
    globalFont.value = value;
    PrefsHelper.themeFont = value;
    Get.forceAppUpdate();
  }

  void changeTransition(String value) {
    if (value == transition.value) return;
    transition.value = value;
    PrefsHelper.transition = value;
    Get.forceAppUpdate();
  }

  void changeTextScaleFactor(double value) {
    if (value == textScaleFactor.value) return;
    textScaleFactor.value = value;
    PrefsHelper.textScaleFactor = value;
    Get.forceAppUpdate();
  }

  void changeLanguage(String value) {
    if (value == language.value) return;
    language.value = value;
    PrefsHelper.language = value;
    if (value != 'system') {
      Get.updateLocale(Locale(value.split('_').first, value.split('_').last));
    } else {
      Get.updateLocale(Get.deviceLocale ?? const Locale('en', 'US'));
    }
  }

  Future<void> deleteFont(String font) async {
    await FontHelper.deleteFont(font);
    await refreshFontList();
    changeGlobalFont("system");
  }

  Future<void> refreshFontList() async {
    await FontHelper.readAllFont().then(
      (value) => fontList.value = ["system", ...value],
    );
  }

  // import font
  Future<void> importFont() async {
    await FontHelper.loadLocalFont();
    await refreshFontList();
  }
}
