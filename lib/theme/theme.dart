import 'package:flutter/material.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

/// 浅色主题
ThemeData lightTheme(BuildContext context, ColorScheme? lightDynamic) {
  ColorScheme colorScheme =
      (context.watch<ThemeProvider>().isDynamicColor && lightDynamic != null)
          ? lightDynamic
          : ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            );
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: context.watch<ThemeProvider>().themeFont,
    colorScheme: colorScheme,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    ),
  );
}

/// 深色主题
ThemeData darkTheme(BuildContext context, ColorScheme? darkDynamic) {
  ColorScheme colorScheme =
      (context.watch<ThemeProvider>().isDynamicColor && darkDynamic != null)
          ? darkDynamic
          : ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            );
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: context.watch<ThemeProvider>().themeFont,
    colorScheme: colorScheme,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    ),
  );
}
