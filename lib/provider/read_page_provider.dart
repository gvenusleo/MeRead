import 'package:flutter/material.dart';

import '../global/global.dart';

class ReadPageProvider extends ChangeNotifier {
  int fontSize = prefs.getInt('fontSize') ?? 18;
  double lineHeight = prefs.getDouble('lineheight') ?? 1.5;
  int pagePadding = prefs.getInt('pagePadding') ?? 18;
  String textAlign = prefs.getString('textAlign') ?? 'justify';
  String customCss = prefs.getString('customCss') ?? '';

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

  Future<void> changeCustomCss(String css) async {
    await prefs.setString('customCss', css);
    setState(() {
      customCss = css;
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
