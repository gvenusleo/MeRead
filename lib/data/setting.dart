import 'package:shared_preferences/shared_preferences.dart';

// 颜色主题
Future<int> getThemeIndex() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('themeIndex') ?? 2;
}

Future<void> setThemeIndex(int index) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('themeIndex', index);
}

// 主题字体
Future<String> getThemeFont() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('themeFont') ?? '默认字体';
}

Future<void> setThemeFont(String themeFont) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('themeFont', themeFont);
}

// 字体大小
Future<int> getFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('fontSize') ?? 18;
}

Future<void> setFontSize(int size) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('fontSize', size);
}

// 行间距
Future<double> getLineheight() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('lineheight') ?? 1.5;
}

Future<void> setLineheight(double height) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setDouble('lineheight', height);
}

// 页边距
Future<int> getPagePadding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('pagePadding') ?? 18;
}

Future<void> setPagePadding(int padding) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('pagePadding', padding);
}

// 文字对齐
Future<String> getTextAlign() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('textAlign') ?? 'justify';
}

Future<void> setTextAlign(String align) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('textAlign', align);
}

// 自定义 CSS
Future<String> getCustomCss() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('customCss') ?? '';
}

Future<void> setCustomCss(String css) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('customCss', css);
}
