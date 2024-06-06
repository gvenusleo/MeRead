import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meread/common/init_app.dart';
import 'package:meread/helpers/prefs_helper.dart';
import 'package:meread/helpers/routes_helper.dart';
import 'package:meread/helpers/theme_helper.dart';
import 'package:meread/translation/translation.dart';

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
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
          ],
          locale: PrefsHelper.language == 'system'
              ? Get.deviceLocale
              : Locale(PrefsHelper.language.split('_').first,
                  PrefsHelper.language.split('_').last),
          fallbackLocale: const Locale('en', 'US'),
          translations: AppTranslation(),
          theme: ThemeHelp.buildLightTheme(lightDynamic),
          darkTheme: ThemeHelp.buildDarkTheme(darkDynamic),
          themeMode: [
            ThemeMode.system,
            ThemeMode.light,
            ThemeMode.dark,
          ][PrefsHelper.themeMode],
          initialRoute: RouteHelp.initRoute,
          getPages: RouteHelp.routes,
          defaultTransition: {
            'cupertino': Transition.cupertino,
            'fade': Transition.fade,
          }[PrefsHelper.transition],
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
