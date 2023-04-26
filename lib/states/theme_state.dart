import 'package:flutter/material.dart';

import '../data/setting.dart';

class ThemeState extends ChangeNotifier {
  ThemeState() {
    initData();
  }
  int themeIndex = 0;
  String themeFont = '默认字体';
  Future<void> initData() async {
    final int index = await getThemeIndex();
    final String font = await getThemeFont();
    setState(() {
      themeIndex = index;
      themeFont = font;
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

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
