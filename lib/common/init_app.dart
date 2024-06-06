import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meread/helpers/dio_helper.dart';
import 'package:meread/helpers/font_helper.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/helpers/prefs_helper.dart';

/// Init App
Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  LogHelper.init();
  await PrefsHelper.init();
  await IsarHelper.init();
  DioHelper.init();

  FontHelper.readThemeFont();
}
