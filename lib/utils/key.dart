import 'package:shared_preferences/shared_preferences.dart';

// flomo 接口数据管理
Future<bool> getUseFlomo() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('useFlomo') ?? false;
}

Future<void> setUseFlomo(bool use) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('useFlomo', use);
}

Future<String> getFlomoApiKey() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('flomoApiKey') ?? '';
}

Future<void> setFlomoApiKey(String apiKey) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('flomoApiKey', apiKey);
}

Future<String> getFlomoTag() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('flomoTag') ?? '';
}

Future<void> setFlomoTag(String tag) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('flomoTag', tag);
}

Future<bool> getUseCategoryAsTag() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('useCategoryAsTag') ?? false;
}

Future<void> setUseCategoryAsTag(bool use) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('useCategoryAsTag', use);
}

Future<bool> getSavePostLink() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('savePostLink') ?? false;
}

Future<void> setSavePostLink(bool save) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('savePostLink', save);
}

// 订阅源解析数据管理
Future<String> getDefaultCategory() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('defaultCategory') ?? '默认分类';
}

Future<void> setDefalutCategory(String category) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('defaultCategory', category);
}

Future<int> getDefaultOpenType() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('defaultOpenType') ?? 0;
}

Future<void> setDefaultOpenType(int type) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('defaultOpenType', type);
}

Future<int> getFeedMaxSaveCount() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('feedMaxSaveCount') ?? 50;
}

Future<void> setFeedMaxSaveCount(int count) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('feedMaxSaveCount', count);
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

Future<bool> getEndAddLink() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('endAddLink') ?? false;
}

Future<void> setEndAddLink(bool end) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('endAddLink', end);
}

Future<Map<String, dynamic>> getAllReadPageInitData() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'fontSize': prefs.getInt('fontSize') ?? 18,
    'lineheight': prefs.getDouble('lineheight') ?? 1.5,
    'pagePadding': prefs.getInt('pagePadding') ?? 18,
    'textAlign': prefs.getString('textAlign') ?? 'justify',
    'endAddLink': prefs.getBool('endAddLink') ?? false,
    'useFlomo': prefs.getBool('useFlomo') ?? false,
    'flomoApiKey': prefs.getString('flomoApiKey') ?? '',
    'flomoTag': prefs.getString('flomoTag') ?? '',
    'useCategoryAsTag': prefs.getBool('useCategoryAsTag') ?? false,
    'savePostLink': prefs.getBool('savePostLink') ?? false,
  };
}
