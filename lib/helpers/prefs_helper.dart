import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get language => _prefs.getString('language') ?? 'system';
  static set language(String value) => _prefs.setString('language', value);

  static int get themeMode => _prefs.getInt('themeMode') ?? 0;
  static set themeMode(int value) => _prefs.setInt('themeMode', value);

  static String get themeFont => _prefs.getString('themeFont') ?? 'defaultFont';
  static set themeFont(String value) => _prefs.setString('themeFont', value);

  static double get textScaleFactor =>
      _prefs.getDouble('textScaleFactor') ?? 1.0;
  static set textScaleFactor(double value) =>
      _prefs.setDouble('textScaleFactor', value);

  static bool get useDynamicColor => _prefs.getBool('useDynamicColor') ?? true;
  static set useDynamicColor(bool value) =>
      _prefs.setBool('useDynamicColor', value);

  static int get readFontSize => _prefs.getInt('readFontSize') ?? 18;
  static set readFontSize(int value) => _prefs.setInt('readFontSize', value);

  static double get readLineHeight => _prefs.getDouble('readLineHeight') ?? 1.5;
  static set readLineHeight(double value) =>
      _prefs.setDouble('readLineHeight', value);

  static int get readPagePadding => _prefs.getInt('readPagePadding') ?? 18;
  static set readPagePadding(int value) =>
      _prefs.setInt('readPagePadding', value);

  static String get readTextAlign =>
      _prefs.getString('readTextAlign') ?? 'justify';
  static set readTextAlign(String value) =>
      _prefs.setString('readTextAlign', value);

  static bool get refreshOnStartup =>
      _prefs.getBool('refreshOnStartup') ?? true;
  static set refreshOnStartup(bool value) =>
      _prefs.setBool('refreshOnStartup', value);

  static List<String> get blockList => _prefs.getStringList('blockList') ?? [];
  static set blockList(List<String> value) =>
      _prefs.setStringList('blockList', value);

  static bool get useProxy => _prefs.getBool('useProxy') ?? false;
  static set useProxy(bool value) => _prefs.setBool('useProxy', value);

  static String get proxyAddress => _prefs.getString('proxyAddress') ?? '';
  static set proxyAddress(String value) =>
      _prefs.setString('proxyAddress', value);

  static String get proxyPort => _prefs.getString('proxyPort') ?? '';
  static set proxyPort(String value) => _prefs.setString('proxyPort', value);
}
