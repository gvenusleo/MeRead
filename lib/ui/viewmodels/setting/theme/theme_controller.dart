import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/font_helper.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/helpers/prefs_helper.dart';

class ThemeController extends GetxController {
  final RxInt themeMode = (PrefsHelper.themeMode).obs;
  final RxBool useDynamicColor = (PrefsHelper.useDynamicColor).obs;
  final RxDouble textScaleFactor = (PrefsHelper.textScaleFactor).obs;
  final RxString themeFont = (PrefsHelper.themeFont).obs;
  final RxList<String> fonts = <String>[].obs;

  @override
  void onInit() {
    readAllFont();
    super.onInit();
  }

  void updateThemeMode(int value) {
    if (themeMode.value == value) return;
    themeMode.value = value;
    PrefsHelper.themeMode = value;
    Get.changeThemeMode(
      [ThemeMode.system, ThemeMode.light, ThemeMode.dark][value],
    );
    LogHelper.i('[Setting] Change theme mode to: ${[
      ThemeMode.system,
      ThemeMode.light,
      ThemeMode.dark
    ][value]}');
  }

  void updateDynamicColor(bool value) {
    if (useDynamicColor.value == value) return;
    useDynamicColor.value = value;
    PrefsHelper.useDynamicColor = value;
    Get.forceAppUpdate();
    LogHelper.i('[Setting] Change dynamic color to: $value');
  }

  void updateTextScaleFactor(double value) {
    if (textScaleFactor.value == value) return;
    textScaleFactor.value = value;
    PrefsHelper.textScaleFactor = value;
    Get.forceAppUpdate();
    LogHelper.i('[Setting] Change text scale factor to: $value');
  }

  void updateThemeFont(String value) {
    if (themeFont.value == value) return;
    themeFont.value = value;
    PrefsHelper.themeFont = value;
    Get.forceAppUpdate();
    LogHelper.i('[Setting] Change theme font to: $value');
  }

  Future<void> readAllFont() async {
    fonts.value = await FontHelper.readAllFont();
  }

  Future<void> loadLocalFont() async {
    bool statue = await FontHelper.loadLocalFont();
    if (statue) {
      readAllFont();
    }
  }

  Future<void> deleteFont(String font) async {
    await FontHelper.deleteFont(font);
    LogHelper.i('[Setting] Delete font: $font');
    if (themeFont.value == font) {
      updateThemeFont('defaultFont');
    }
    readAllFont();
  }
}
