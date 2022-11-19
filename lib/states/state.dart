import 'package:flutter/material.dart';

import '../utils/key.dart';

class ThemeModel extends ChangeNotifier {
  ThemeModel() {
    getTheme();
  }
  int themeIndex = 0;
  Future<void> getTheme() async {
    final int index = await getThemeIndex();
    setState(() {
      themeIndex = index;
    });
  }

  Future<void> setTheme(int index) async {
    await setThemeIndex(index);
    setState(() {
      themeIndex = index;
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
