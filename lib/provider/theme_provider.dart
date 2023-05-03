import 'package:flutter/material.dart';
import '../../global/global.dart';

class ThemeProvider extends ChangeNotifier {
  int themeIndex = prefs.getInt('themeIndex') ?? 2;
  String themeFont = prefs.getString('themeFont') ?? '默认字体';
  bool isDynamicColor = prefs.getBool('dynamicColor') ?? false;

  Future<void> changeThemeIndex(int index) async {
    await prefs.setInt('themeIndex', index);
    setState(() {
      themeIndex = index;
    });
  }

  Future<void> setThemeFontState(String font) async {
    await prefs.setString('themeFont', font);
    setState(() {
      themeFont = font;
    });
  }

  Future<void> setDynamicColorState(bool dynamicColor) async {
    await prefs.setBool('dynamicColor', dynamicColor);
    setState(() {
      isDynamicColor = dynamicColor;
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
