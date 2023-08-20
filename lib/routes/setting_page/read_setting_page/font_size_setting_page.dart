import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class FontSizeSettingPage extends StatelessWidget {
  const FontSizeSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<int, String> fontSizeMap = {
      14: AppLocalizations.of(context)!.minimum,
      16: AppLocalizations.of(context)!.small,
      18: AppLocalizations.of(context)!.medium,
      20: AppLocalizations.of(context)!.large,
      22: AppLocalizations.of(context)!.maximum,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.fontSize),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: fontSizeMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: fontSizeMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().fontSize,
              title: Text(fontSizeMap.values.toList()[index]),
              onChanged: (int? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().changeFontSize(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
