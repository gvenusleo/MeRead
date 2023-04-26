import 'package:flutter/material.dart';

import '../data/setting.dart';

class ReadPageProvider extends ChangeNotifier {
  ReadPageProvider() {
    initData();
  }

  int fontSize = 18;
  double lineHeight = 1.5;
  int pagePadding = 18;
  String textAlign = 'justify';
  String customCss = '';

  Future<void> initData() async {
    final int size = await getFontSize();
    final double height = await getLineheight();
    final int padding = await getPagePadding();
    final String align = await getTextAlign();
    final String css = await getCustomCss();
    setState(() {
      fontSize = size;
      lineHeight = height;
      pagePadding = padding;
      textAlign = align;
      customCss = css;
    });
  }

  Future<void> setFontSizeState(int size) async {
    await setFontSize(size);
    setState(() {
      fontSize = size;
    });
  }

  Future<void> setLineHeightState(double height) async {
    await setLineheight(height);
    setState(() {
      lineHeight = height;
    });
  }

  Future<void> setPagePaddingState(int padding) async {
    await setPagePadding(padding);
    setState(() {
      pagePadding = padding;
    });
  }

  Future<void> setTextAlignState(String align) async {
    await setTextAlign(align);
    setState(() {
      textAlign = align;
    });
  }

  Future<void> setCustomCssState(String css) async {
    await setCustomCss(css);
    setState(() {
      customCss = css;
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
