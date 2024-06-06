import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// App Language
  static String get language => _prefs.getString('language') ?? 'system';
  static set language(String value) => _prefs.setString('language', value);

  // Theme mode
  static int get themeMode => _prefs.getInt('themeMode') ?? 0;
  static set themeMode(int value) => _prefs.setInt('themeMode', value);

  // Theme font
  static String get themeFont => _prefs.getString('themeFont') ?? 'system';
  static set themeFont(String value) => _prefs.setString('themeFont', value);

  // Use dynamic color
  static bool get useDynamicColor => _prefs.getBool('useDynamicColor') ?? true;
  static set useDynamicColor(bool value) =>
      _prefs.setBool('useDynamicColor', value);

  // Transition: {'cupertino': Transition.cupertino, 'fade': Transition.fade}
  static String get transition => _prefs.getString('transition') ?? 'cupertino';
  static set transition(String value) => _prefs.setString('transition', value);

  // Text scale factor
  static double get textScaleFactor =>
      _prefs.getDouble('textScaleFactor') ?? 1.0;
  static set textScaleFactor(double value) =>
      _prefs.setDouble('textScaleFactor', value);

  // Read view font size
  static int get readFontSize => _prefs.getInt('readFontSize') ?? 18;
  static set readFontSize(int value) => _prefs.setInt('readFontSize', value);

  // Read view line height
  static double get readLineHeight => _prefs.getDouble('readLineHeight') ?? 1.5;
  static set readLineHeight(double value) =>
      _prefs.setDouble('readLineHeight', value);

  // Read view page padding
  static int get readPagePadding => _prefs.getInt('readPagePadding') ?? 18;
  static set readPagePadding(int value) =>
      _prefs.setInt('readPagePadding', value);

  // Read view text align
  static String get readTextAlign =>
      _prefs.getString('readTextAlign') ?? 'justify';
  static set readTextAlign(String value) =>
      _prefs.setString('readTextAlign', value);

  /// Refresh feeds on startup
  static bool get refreshOnStartup =>
      _prefs.getBool('refreshOnStartup') ?? true;
  static set refreshOnStartup(bool value) =>
      _prefs.setBool('refreshOnStartup', value);

  /// Bolck list when refresh feeds
  static List<String> get blockList => _prefs.getStringList('blockList') ?? [];
  static set blockList(List<String> value) =>
      _prefs.setStringList('blockList', value);

  /// Use proxy
  static bool get useProxy => _prefs.getBool('useProxy') ?? false;
  static set useProxy(bool value) => _prefs.setBool('useProxy', value);

  // Proxy address
  static String get proxyAddress => _prefs.getString('proxyAddress') ?? '';
  static set proxyAddress(String value) =>
      _prefs.setString('proxyAddress', value);

  // Proxy port
  static String get proxyPort => _prefs.getString('proxyPort') ?? '';
  static set proxyPort(String value) => _prefs.setString('proxyPort', value);
}
