import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'NotoSerifSC',
  primaryColor: Colors.white,
  colorScheme: const ColorScheme(
    primary: Colors.black,
    secondary: Colors.black,
    surface: Colors.black,
    background: Colors.black,
    error: Colors.black,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.black,
    outline: Colors.black54,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
  appBarTheme: const AppBarTheme(
    elevation: 1,
    color: Colors.white,
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: Colors.black54,
        width: 1,
      ),
      minimumSize: const Size(80, 40),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black54,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black87,
        width: 1,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black54,
        width: 1,
      ),
    ),
    labelStyle: TextStyle(
      color: Colors.black,
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(Colors.white),
    trackColor: MaterialStateProperty.all(Colors.grey),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(
      color: Colors.white70,
      fontFamily: 'NotoSerifSC',
      fontWeight: FontWeight.w700,
      fontSize: 16,
    ),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(Colors.black),
  ),
);

Color darkThemeColor = const Color.fromRGBO(220, 220, 220, 1);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'NotoSerifSC',
  primaryColor: Colors.white,
  colorScheme: ColorScheme(
    primary: darkThemeColor,
    secondary: darkThemeColor,
    surface: darkThemeColor,
    background: darkThemeColor,
    error: darkThemeColor,
    onPrimary: darkThemeColor,
    onSecondary: darkThemeColor,
    onSurface: darkThemeColor,
    onBackground: darkThemeColor,
    onError: darkThemeColor,
    outline: Colors.grey,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color.fromRGBO(33, 33, 33, 1),
  appBarTheme: AppBarTheme(
    elevation: 3,
    color: const Color.fromRGBO(33, 33, 33, 1),
    foregroundColor: darkThemeColor,
    centerTitle: true,
  ),
  textTheme: TextTheme(
    headlineSmall: TextStyle(
      fontSize: 18,
      color: darkThemeColor,
      fontWeight: FontWeight.w700,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: darkThemeColor,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: darkThemeColor,
      fontWeight: FontWeight.w500,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: Colors.grey,
        width: 1,
      ),
      minimumSize: const Size(80, 40),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: darkThemeColor,
        width: 1,
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
  ),
  listTileTheme: ListTileThemeData(
    textColor: darkThemeColor,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(darkThemeColor),
    trackColor: MaterialStateProperty.all(Colors.grey),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: darkThemeColor,
    contentTextStyle: const TextStyle(
      color: Colors.black,
      fontFamily: 'NotoSerifSC',
      fontWeight: FontWeight.w700,
      fontSize: 16,
    ),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(darkThemeColor),
  ),
);
