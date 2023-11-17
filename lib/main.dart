import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:meread/global/init.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:meread/routes/home_page.dart';
import 'package:meread/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  await init();
  runApp(
    MultiProvider(
      providers: [
        // 主题状态管理
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // 阅读页面配置状态管理
        ChangeNotifierProvider(create: (_) => ReadPageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MeRead',
          locale: context.watch<ThemeProvider>().language == 'local'
              ? null
              : Locale(context.watch<ThemeProvider>().language),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
          ],
          theme: lightTheme(
            context,
            lightDynamic,
          ),
          darkTheme: darkTheme(
            context,
            darkDynamic,
          ),
          themeMode: [
            ThemeMode.light,
            ThemeMode.dark,
            ThemeMode.system,
          ][context.watch<ThemeProvider>().themeIndex],
          home: const HomePage(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  context.watch<ThemeProvider>().textScaleFactor,
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
