import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({super.key, this.needLeading = true});

  final bool needLeading;

  @override
  Widget build(BuildContext context) {
    List<String> themeMode = [
      AppLocalizations.of(context)!.lightMode,
      AppLocalizations.of(context)!.darkMode,
      AppLocalizations.of(context)!.followSystem,
    ];
    return Scaffold(
      appBar: AppBar(
        leading: needLeading ? null : const SizedBox.shrink(),
        leadingWidth: needLeading ? null : 0,
        title: Text(AppLocalizations.of(context)!.themeMode),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: themeMode.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: index,
              groupValue: context.watch<ThemeProvider>().themeIndex,
              title: Text(themeMode[index]),
              onChanged: (int? value) async {
                if (value != null) {
                  context.read<ThemeProvider>().changeThemeIndex(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
