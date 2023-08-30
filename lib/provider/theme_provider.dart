import 'package:flutter/material.dart';
import 'package:meread/global/global.dart';

/// App 主题状态管理
class ThemeProvider extends ChangeNotifier {
  // App 语言
  String language = prefs.getString('language') ?? 'local';
  // 颜色主题：0-浅色模式，1-深色模式，2-跟随系统
  int themeIndex = prefs.getInt('themeIndex') ?? 2;
  // 全局字体
  String themeFont = prefs.getString('themeFont') ?? '默认字体';
  // 全局缩放
  double textScaleFactor = prefs.getDouble('textScaleFactor') ?? 1.0;
  // 动态取色
  bool isDynamicColor = prefs.getBool('dynamicColor') ?? false;

  Future<void> changeLanguage(String language) async {
    await prefs.setString('language', language);
    setState(() {
      this.language = language;
    });
  }

  Future<void> changeThemeIndex(int index) async {
    await prefs.setInt('themeIndex', index);
    setState(() {
      themeIndex = index;
    });
  }

  Future<void> changeThemeFont(String font) async {
    await prefs.setString('themeFont', font);
    setState(() {
      themeFont = font;
    });
  }

  Future<void> changeTextScaleFactor(double factor) async {
    await prefs.setDouble('textScaleFactor', factor);
    setState(() {
      textScaleFactor = factor;
    });
  }

  Future<void> changeDynamicColor(bool dynamicColor) async {
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
