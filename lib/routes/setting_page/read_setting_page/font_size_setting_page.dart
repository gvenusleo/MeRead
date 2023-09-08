import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class FontSizeSettingPage extends StatefulWidget {
  const FontSizeSettingPage({Key? key}) : super(key: key);

  @override
  State<FontSizeSettingPage> createState() => _FontSizeSettingPageState();
}

class _FontSizeSettingPageState extends State<FontSizeSettingPage> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return buildScaffold();
    } else {
      if (MediaQuery.of(context).size.width < 600) {
        return buildScaffold();
      } else {
        return Scaffold(
          body: Row(
            children: [
              Container(
                width: 600,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: buildScaffold(),
              )
            ],
          ),
        );
      }
    }
  }

  Widget buildScaffold() {
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
