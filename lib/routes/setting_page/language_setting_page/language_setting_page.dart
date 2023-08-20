import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageMap = {
      'local': AppLocalizations.of(context)!.systemLanguage,
      'zh': '简体中文',
      'en': 'English',
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.languageSetting),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: languageMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: languageMap.keys.toList()[index],
              groupValue: context.watch<ThemeProvider>().language,
              title: Text(languageMap.values.toList()[index]),
              onChanged: (value) {
                if (value != null) {
                  context.read<ThemeProvider>().changeLanguage(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
