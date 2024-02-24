import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

import 'package:meread/common/global.dart';
import 'package:meread/common/helpers/font_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/dio_helper.dart';

/// App 初始化
Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  /* Android 平台适配 */
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  /* 初始化全局变量 */
  logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: false,
      printTime: true,
    ),
  );
  prefs = await SharedPreferences.getInstance();
  appDio = DioHelper();
  final Directory dir = Platform.isAndroid
      ? await getApplicationDocumentsDirectory()
      : await getApplicationSupportDirectory();
  isar = await Isar.open(
    [FeedSchema, PostSchema],
    directory: dir.path,
  );
  logger.i('[Isar]: 打开数据库 ${dir.path}');

  /* 读取主题字体 */
  FontHelper.readThemeFont();
}
