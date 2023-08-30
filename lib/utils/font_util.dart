import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:meread/global/global.dart';
import 'package:path_provider/path_provider.dart';

/// 读取所有字体文件，注册到系统中
/// 返回字体名称列表
Future<List<String>> readAllFont() async {
  List<String> fontNameList = [];
  final fontDir = await getFontDir();
  /* 遍历字体文件目录，将字体文件注册到系统中 */
  for (var fontFile in fontDir.listSync()) {
    final fontName = fontFile.path.split('/').last;
    readFont('${fontDir.path}/$fontName', fontName);
    fontNameList.add(fontName);
  }
  return fontNameList;
}

/// 读取主题字体文件，注册到系统中
Future<void> readThemeFont() async {
  final String themeFontName = prefs.getString('themeFont') ?? '默认字体';
  if (themeFontName != '默认字体') {
    final fontFileDir = await getFontDir();
    readFont('${fontFileDir.path}/$themeFontName', themeFontName);
  }
}

/// 读取指定字体文件到系统中
/// fontFilePath: 字体文件路径
/// fontName: 字体文件名称
Future<void> readFont(String fontFilePath, String fontName) async {
  final fontFile = File(fontFilePath);
  final fontFileBytes = await fontFile.readAsBytes();
  final fontLoad = FontLoader(fontName);
  fontLoad.addFont(Future.value(ByteData.view(fontFileBytes.buffer)));
  fontLoad.load();
}

/// 删除指定字体文件
Future<void> deleteFont(String fontName) async {
  final fontFileDir = await getFontDir();
  final fontFile = File('${fontFileDir.path}/$fontName');
  if (fontFile.existsSync()) {
    fontFile.deleteSync();
  }
}

/// 本地字体文件导入到 app 工作目录中
Future<bool> loadLocalFont() async {
  try {
    /* 获取字体文件 */
    final fontFilePicker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ttf', 'otf', '.ttc'],
      allowMultiple: true,
    );
    if (fontFilePicker != null) {
      List<File> fontFileList =
          fontFilePicker.paths.map((path) => File(path!)).toList();
      /* 将字体文件导入到 app 中 */
      final fontFileDir = await getFontDir();
      for (var fontFile in fontFileList) {
        final fontFileName = fontFile.path.split('/').last;
        final newFontPath = '${fontFileDir.path}/$fontFileName';
        await fontFile.copy(newFontPath);
        /* 删除原缓存文件 */
        await fontFile.delete();
      }
    }
    return true;
  } catch (e) {
    return false;
  }
}

/// 获取字体文件目录
Future<Directory> getFontDir() async {
  final Directory appWorkDir = await getApplicationDocumentsDirectory();
  final String fontDirPath = '${appWorkDir.path}/fonts';
  final Directory fontDir = Directory(fontDirPath);
  if (!(await fontDir.exists())) {
    await fontDir.create(recursive: true);
  }
  return fontDir;
}
