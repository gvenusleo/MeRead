import 'package:flutter/material.dart';

import '../data/setting.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    initData();
  }

  int themeIndex = 0;
  String themeFont = '默认字体';
  bool isDynamicColor = false;

  Future<void> initData() async {
    final int index = await getThemeIndex();
    final String font = await getThemeFont();
    final bool dynamicColor = await getDynamicColor();
    setState(() {
      themeIndex = index;
      themeFont = font;
      isDynamicColor = dynamicColor;
    });
  }

  Future<void> setThemeIndexState(int index) async {
    await setThemeIndex(index);
    setState(() {
      themeIndex = index;
    });
  }

  Future<void> setThemeFontState(String font) async {
    await setThemeFont(font);
    setState(() {
      themeFont = font;
    });
  }

  Future<void> setDynamicColorState(bool dynamicColor) async {
    await setDynamicColor(dynamicColor);
    setState(() {
      isDynamicColor = dynamicColor;
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
