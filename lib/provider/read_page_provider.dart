import 'package:flutter/material.dart';
import 'package:meread/global/global.dart';

/// 阅读页面配置状态管理
class ReadPageProvider extends ChangeNotifier {
  // 字体大小
  int fontSize = prefs.getInt('fontSize') ?? 18;
  // 行高
  double lineHeight = prefs.getDouble('lineheight') ?? 1.5;
  // 页面左右边距
  int pagePadding = prefs.getInt('pagePadding') ?? 18;
  // 文字对齐方式
  String textAlign = prefs.getString('textAlign') ?? 'justify';

  Future<void> changeFontSize(int size) async {
    await prefs.setInt('fontSize', size);
    setState(() {
      fontSize = size;
    });
  }

  Future<void> changeLineHeight(double height) async {
    await prefs.setDouble('lineheight', height);
    setState(() {
      lineHeight = height;
    });
  }

  Future<void> changePagePadding(int padding) async {
    await prefs.setInt('pagePadding', padding);
    setState(() {
      pagePadding = padding;
    });
  }

  Future<void> changeTextAlign(String align) async {
    await prefs.setString('textAlign', align);
    setState(() {
      textAlign = align;
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
