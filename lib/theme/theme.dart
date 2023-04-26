import 'package:flutter/material.dart';

ThemeData lightTheme(String font) {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: font,
    colorSchemeSeed: Colors.indigo,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    ),
  );
}

ThemeData darkTheme(String font) {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: font,
    colorSchemeSeed: Colors.indigo,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    ),
  );
}
