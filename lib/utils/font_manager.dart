import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:meread/data/setting.dart';

import 'dir.dart';

// 读取所有字体文件，注册到系统中
Future<List<String>> readAll() async {
  List<String> fontNameList = [];
  final fontFileDir = Directory(await getFontDir());
  // 遍历字体文件目录，将字体文件注册到系统中
  for (var fontFile in fontFileDir.listSync()) {
    final fontFileName = fontFile.path.split('/').last;
    final fontFileNew = File('${fontFileDir.path}/$fontFileName');
    final fontFileBytes = await fontFileNew.readAsBytes();
    final fontLoad = FontLoader(fontFileName);
    fontLoad.addFont(Future.value(ByteData.view(fontFileBytes.buffer)));
    await fontLoad.load();
    fontNameList.add(fontFileName);
  }
  return fontNameList;
}

// 读取主题字体文件，注册到系统中
Future<void> readThemeFont() async {
  final String themeFont = await getThemeFont();
  if (themeFont != '默认字体') {
    final fontFileDir = Directory(await getFontDir());
    final fontFile = File('${fontFileDir.path}/$themeFont');
    final fontFileBytes = await fontFile.readAsBytes();
    final fontLoad = FontLoader(themeFont);
    fontLoad.addFont(Future.value(ByteData.view(fontFileBytes.buffer)));
    await fontLoad.load();
  }
}

// 删除指定字体文件
Future<void> delete(String fontName) async {
  final fontFileDir = Directory(await getFontDir());
  final fontFile = File('${fontFileDir.path}/$fontName');
  if (fontFile.existsSync()) {
    fontFile.deleteSync();
  }
}

// 本地字体文件导入到 app 工作目录中
Future<bool> loadLocalFont() async {
  try {
    // 获取字体文件
    final fontFilePicker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ttf', 'otf', '.ttc'],
      allowMultiple: true,
    );
    if (fontFilePicker != null) {
      List<File> fontFileList =
          fontFilePicker.paths.map((path) => File(path!)).toList();
      // 将字体文件导入到 app 中
      final fontFileDir = Directory(await getFontDir());
      for (var fontFile in fontFileList) {
        final fontFileName = fontFile.path.split('/').last;
        final newFontPath = '${fontFileDir.path}/$fontFileName';
        await fontFile.copy(newFontPath);
        // 删除原缓存文件
        await fontFile.delete();
      }
    }
    return true;
  } catch (e) {
    return false;
  }
}
