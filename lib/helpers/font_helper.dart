import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/helpers/prefs_helper.dart';
import 'package:path_provider/path_provider.dart';

class FontHelper {
  /// Read all font files
  static Future<List<String>> readAllFont() async {
    List<String> fontNameList = [];
    final fontDir = await _getFontDir();
    for (var fontFile in fontDir.listSync()) {
      final fontName = fontFile.path.split(_getDirSeparator()).last;
      _readFont(fontFile.path, fontName);
      fontNameList.add(fontName);
    }
    LogHelper.i('[font]: Read all font files: $fontNameList.');
    return fontNameList;
  }

  /// Read theme font
  static Future<void> readThemeFont() async {
    final String themeFontName = PrefsHelper.themeFont;
    if (themeFontName != 'system') {
      final fontFileDir = await _getFontDir();
      _readFont('${fontFileDir.path}${_getDirSeparator()}$themeFontName',
          themeFontName);
      LogHelper.i('[font]: Read theme font: $themeFontName.');
    }
  }

  /// Delete a font
  static Future<void> deleteFont(String fontName) async {
    if (fontName == 'system') {
      return;
    }
    final fontFileDir = await _getFontDir();
    final fontFile = File('${fontFileDir.path}${_getDirSeparator()}$fontName');
    if (fontFile.existsSync()) {
      fontFile.deleteSync();
      LogHelper.i('[font]: Delete a font: $fontName.');
    }
  }

  /// Import font file
  static Future<bool> loadLocalFont() async {
    try {
      final fontFilePicker = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ttf', 'otf', '.ttc', '.TTF' '.OTF', '.TTC'],
        allowMultiple: true,
      );
      if (fontFilePicker != null) {
        List<File> fontFileList =
            fontFilePicker.paths.map((path) => File(path!)).toList();
        final fontFileDir = await _getFontDir();
        for (var fontFile in fontFileList) {
          final fontFileName = fontFile.path.split(_getDirSeparator()).last;
          final newFontPath =
              '${fontFileDir.path}${_getDirSeparator()}$fontFileName';
          await fontFile.copy(newFontPath);
          LogHelper.i('[font]: Import a font: $fontFileName.');
          // await fontFile.delete();
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Read a font file with file path and font name
  static Future<void> _readFont(String fontFilePath, String fontName) async {
    final fontFile = File(fontFilePath);
    final fontFileBytes = await fontFile.readAsBytes();
    final fontLoad = FontLoader(fontName);
    fontLoad.addFont(Future.value(ByteData.view(fontFileBytes.buffer)));
    fontLoad.load();
  }

  /// Get directory seperator
  static String _getDirSeparator() {
    if (Platform.isWindows) {
      return '\\';
    } else {
      return '/';
    }
  }

  /// Get font diractory
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
