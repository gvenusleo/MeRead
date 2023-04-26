import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:meread/utils/font_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'provider/theme_provider.dart';
import 'theme/theme.dart';
import 'routes/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge, // 适配 EdgeToEdge
  );
  await readThemeFont(); // 读取主题字体
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // 主题状态管理
        ChangeNotifierProvider(create: (_) => ReadPageProvider()), // 阅读页面状态管理
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<ThemeProvider>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MeRead',
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      theme: lightTheme(context.watch<ThemeProvider>().themeFont),
      darkTheme: darkTheme(context.watch<ThemeProvider>().themeFont),
      themeMode: [
        ThemeMode.light,
        ThemeMode.dark,
        ThemeMode.system,
      ][Provider.of<ThemeProvider>(context).themeIndex],
      home: const HomePage(),
    );
  }
}
