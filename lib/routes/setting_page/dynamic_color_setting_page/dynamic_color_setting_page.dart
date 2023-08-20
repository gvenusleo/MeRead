import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class DynamicColorSettingPage extends StatelessWidget {
  const DynamicColorSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dynamicColor),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SwitchListTile(
              value: context.watch<ThemeProvider>().isDynamicColor,
              onChanged: (bool value) async {
                context.read<ThemeProvider>().changeDynamicColor(value);
              },
              title: Text(AppLocalizations.of(context)!.openDynamicColor),
              subtitle:
                  Text(AppLocalizations.of(context)!.dynamicColorFromWallpaper),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(AppLocalizations.of(context)!.dynamicColorInfo),
            ),
          ],
        ),
      ),
    );
  }
}
