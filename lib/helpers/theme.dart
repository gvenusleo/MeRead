import 'package:flutter/material.dart';
import 'package:meread/helpers/prefs_helper.dart';

ThemeData buildLightTheme(ColorScheme? lightColorScheme) {
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
    dividerTheme: const DividerThemeData(
      space: 0,
      thickness: 0,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
}

ThemeData buildDarkTheme(ColorScheme? darkColorScheme) {
  ColorScheme defaultDarkColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: PrefsHelper.themeFont,
    colorScheme: PrefsHelper.useDynamicColor
        ? darkColorScheme ?? defaultDarkColorScheme
        : defaultDarkColorScheme,
    dividerTheme: const DividerThemeData(
      space: 0,
      thickness: 0,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
}
