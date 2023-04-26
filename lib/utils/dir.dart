import 'dart:io';

import 'package:path_provider/path_provider.dart';

// 获取工作目录
Future<String> getWorkDir() async {
  final appDir = await getApplicationDocumentsDirectory();
  return appDir.path;
}

// 获取字体文件目录
Future<String> getFontDir() async {
  String fontDir = '${await getWorkDir()}/fonts';
  if (!(await Directory(fontDir).exists())) {
    await Directory(fontDir).create(recursive: true);
  }
  return fontDir;
}
