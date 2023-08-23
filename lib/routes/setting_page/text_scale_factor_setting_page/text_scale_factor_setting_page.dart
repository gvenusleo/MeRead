import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class TextScaleFactorSettingPage extends StatefulWidget {
  const TextScaleFactorSettingPage({Key? key}) : super(key: key);

  @override
  State<TextScaleFactorSettingPage> createState() =>
      _TextScaleFactorSettingPageState();
}

class _TextScaleFactorSettingPageState
    extends State<TextScaleFactorSettingPage> {
  @override
  Widget build(BuildContext context) {
    double textScaleFactor = context.read<ThemeProvider>().textScaleFactor;
    final Map<double, String> textScaleFactorMap = {
      0.8: AppLocalizations.of(context)!.minimum,
      0.9: AppLocalizations.of(context)!.small,
      1.0: AppLocalizations.of(context)!.medium,
      1.1: AppLocalizations.of(context)!.large,
      1.2: AppLocalizations.of(context)!.maximum,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.globalScale),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: textScaleFactorMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: textScaleFactorMap.keys.toList()[index],
              groupValue: textScaleFactor,
              title: Text(textScaleFactorMap.values.toList()[index]),
              onChanged: (double? value) async {
                if (value != null) {
                  await context
                      .read<ThemeProvider>()
                      .changeTextScaleFactor(value);
                  setState(() {
                    textScaleFactor = value;
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }
}
