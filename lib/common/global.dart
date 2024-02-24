import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:meread/common/helpers/dio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 全局变量
late Logger logger;
late SharedPreferences prefs;
late Isar isar;
late DioHelper appDio;
String applicationVersion = 'v0.6.1';
