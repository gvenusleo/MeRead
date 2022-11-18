import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  ThemeModel() {
    getThemeIndex();
  }
  int themeIndex = 0;
  Future<void> getThemeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      themeIndex = prefs.getInt('themeIndex') ?? 2;
    });
  }

  Future<void> setThemeIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      themeIndex = index;
      prefs.setInt('themeIndex', index);
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
