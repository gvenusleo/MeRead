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

// 订阅源解析数据管理
Future<int> getFeedMaxSaveCount() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('feedMaxSaveCount') ?? 50;
}

Future<void> setFeedMaxSaveCount(int count) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('feedMaxSaveCount', count);
}

Future<bool> getAllowDuplicate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('allowDuplicate') ?? false;
}

Future<void> setAllowDuplicate(bool allow) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('allowDuplicate', allow);
}

// 阅读页面数据管理
Future<int> getFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('fontSize') ?? 18;
}

Future<void> setFontSize(int size) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('fontSize', size);
}

Future<double> getLineheight() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('lineheight') ?? 1.5;
}

Future<void> setLineheight(double height) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setDouble('lineheight', height);
}

Future<int> getPagePadding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('pagePadding') ?? 18;
}

Future<void> setPagePadding(int padding) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('pagePadding', padding);
}

Future<String> getTextAlign() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('textAlign') ?? 'justify';
}

Future<void> setTextAlign(String align) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('textAlign', align);
}

Future<String> getCustomCss() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('customCss') ?? '';
}

Future<void> setCustomCss(String css) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('customCss', css);
}

Future<Map<String, dynamic>> getAllReadPageInitData() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'fontSize': prefs.getInt('fontSize') ?? 18,
    'lineheight': prefs.getDouble('lineheight') ?? 1.5,
    'pagePadding': prefs.getInt('pagePadding') ?? 18,
    'textAlign': prefs.getString('textAlign') ?? 'justify',
    'customCss': prefs.getString('customCss') ?? '',
  };
}
