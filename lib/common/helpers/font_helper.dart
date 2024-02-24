import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:meread/common/helpers/prefs_helper.dart';
import 'package:path_provider/path_provider.dart';

class FontHelper {
  /// 读取所有字体文件，注册到系统中
  /// 返回字体名称列表
  static Future<List<String>> readAllFont() async {
    List<String> fontNameList = [];
    final fontDir = await _getFontDir();
    /* 遍历字体文件目录，将字体文件注册到系统中 */
    for (var fontFile in fontDir.listSync()) {
      final fontName = fontFile.path.split(_getDirSeparator()).last;
      _readFont(fontFile.path, fontName);
      fontNameList.add(fontName);
    }
    fontNameList.insert(0, 'defaultFont');
    return fontNameList;
  }

  /// 读取主题字体文件，注册到系统中
  static Future<void> readThemeFont() async {
    final String themeFontName = PrefsHelper.themeFont;
    if (themeFontName != 'defaultFont') {
      final fontFileDir = await _getFontDir();
      _readFont('${fontFileDir.path}${_getDirSeparator()}$themeFontName',
          themeFontName);
    }
  }

  /// 删除指定字体文件
  static Future<void> deleteFont(String fontName) async {
    final fontFileDir = await _getFontDir();
    final fontFile = File('${fontFileDir.path}${_getDirSeparator()}$fontName');
    if (fontFile.existsSync()) {
      fontFile.deleteSync();
    }
  }

  /// 本地字体文件导入到 app 工作目录中
  static Future<bool> loadLocalFont() async {
    try {
      /* 获取字体文件 */
      final fontFilePicker = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ttf', 'otf', '.ttc', '.TTF' '.OTF', '.TTC'],
        allowMultiple: true,
      );
      if (fontFilePicker != null) {
        List<File> fontFileList =
            fontFilePicker.paths.map((path) => File(path!)).toList();
        /* 将字体文件导入到 app 中 */
        final fontFileDir = await _getFontDir();
        for (var fontFile in fontFileList) {
          final fontFileName = fontFile.path.split(_getDirSeparator()).last;
          final newFontPath =
              '${fontFileDir.path}${_getDirSeparator()}$fontFileName';
          await fontFile.copy(newFontPath);
          // /* 删除原缓存文件 */
          // await fontFile.delete();
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 读取指定字体文件到系统中
  /// fontFilePath: 字体文件路径
  /// fontName: 字体文件名称
  static Future<void> _readFont(String fontFilePath, String fontName) async {
    final fontFile = File(fontFilePath);
    final fontFileBytes = await fontFile.readAsBytes();
    final fontLoad = FontLoader(fontName);
    fontLoad.addFont(Future.value(ByteData.view(fontFileBytes.buffer)));
    fontLoad.load();
  }

  /// 判断文件夹路径分隔符
  static String _getDirSeparator() {
    if (Platform.isWindows) {
      return '\\';
    } else {
      return '/';
    }
  }

  /// 获取字体文件目录
  static Future<Directory> _getFontDir() async {
    final Directory appWorkDir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();
    final String fontDirPath = '${appWorkDir.path}${_getDirSeparator()}fonts';
    final Directory fontDir = Directory(fontDirPath);
    if (!(await fontDir.exists())) {
      await fontDir.create(recursive: true);
    }
    return fontDir;
  }
}
