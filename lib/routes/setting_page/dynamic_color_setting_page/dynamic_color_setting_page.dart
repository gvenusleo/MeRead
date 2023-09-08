import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class DynamicColorSettingPage extends StatelessWidget {
  const DynamicColorSettingPage({super.key, this.needLeading = true});
  final bool needLeading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: needLeading ? null : const SizedBox.shrink(),
        leadingWidth: needLeading ? null : 0,
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
