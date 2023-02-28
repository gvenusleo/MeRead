import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'NotoSerifSC',
  colorSchemeSeed: Colors.indigo,
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 24),
  ),
);

Color darkThemeColor = const Color.fromRGBO(220, 220, 220, 1);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'NotoSerifSC',
  colorSchemeSeed: Colors.indigo,
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 24),
  ),
);
