import 'package:flutter/material.dart';
import 'package:meread/helpers/prefs_helper.dart';

class ThemeHelp {
  static ThemeData buildLightTheme(ColorScheme? lightColorScheme) {
    ColorScheme defaultLightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: PrefsHelper.themeFont,
      colorScheme: PrefsHelper.useDynamicColor
          ? lightColorScheme ?? defaultLightColorScheme
          : defaultLightColorScheme,
    );
  }

  static ThemeData buildDarkTheme(ColorScheme? darkColorScheme) {
    ColorScheme defaultDarkColorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue, brightness: Brightness.dark);
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: PrefsHelper.themeFont,
      colorScheme: PrefsHelper.useDynamicColor
          ? darkColorScheme ?? defaultDarkColorScheme
          : defaultDarkColorScheme,
    );
  }
}
