import 'package:meread/utils/font_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
String applicationVersion = 'v0.5.0';

Future<void> init() async {
  prefs = await SharedPreferences.getInstance();
  await readThemeFont(); // 读取主题字体
}
