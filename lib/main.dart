import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/common/helpers/prefs_helper.dart';
import 'package:meread/common/init_app.dart';
import 'package:meread/common/translations.dart';
import 'package:meread/routes/routes.dart';
import 'package:meread/common/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MeRead'.tr,
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('en', 'US'),
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
          ],
          translations: AppTranslations(),
          theme: buildLightTheme(lightDynamic),
          darkTheme: buildDarkTheme(darkDynamic),
          themeMode: [
            ThemeMode.system,
            ThemeMode.light,
            ThemeMode.dark,
          ][PrefsHelper.themeMode],
          initialRoute: '/',
          getPages: AppRputes.routes,
          defaultTransition: Transition.cupertino,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(PrefsHelper.textScaleFactor),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
