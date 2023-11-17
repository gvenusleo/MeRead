import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class LineHeightSettingPage extends StatefulWidget {
  const LineHeightSettingPage({super.key});

  @override
  State<LineHeightSettingPage> createState() => _LineHeightSettingPageState();
}

class _LineHeightSettingPageState extends State<LineHeightSettingPage> {
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
    final Map<double, String> lineHeightMap = {
      1.0: AppLocalizations.of(context)!.minimum,
      1.2: AppLocalizations.of(context)!.small,
      1.5: AppLocalizations.of(context)!.medium,
      1.8: AppLocalizations.of(context)!.large,
      2.0: AppLocalizations.of(context)!.maximum,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.lineHeight),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: lineHeightMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: lineHeightMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().lineHeight,
              title: Text(lineHeightMap.values.toList()[index]),
              onChanged: (double? value) async {
                if (value != null) {
                  context.read<ReadPageProvider>().changeLineHeight(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
