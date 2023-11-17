import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class TextAlignSettingPage extends StatefulWidget {
  const TextAlignSettingPage({super.key});

  @override
  State<TextAlignSettingPage> createState() => _TextAlignSettingPageState();
}

class _TextAlignSettingPageState extends State<TextAlignSettingPage> {
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
    final Map<String, String> textAlignMap = {
      'left': AppLocalizations.of(context)!.leftAlignment,
      'right': AppLocalizations.of(context)!.rightAlignment,
      'center': AppLocalizations.of(context)!.centerAlignment,
      'justify': AppLocalizations.of(context)!.justifyAlignment,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.textAlignment),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: textAlignMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: textAlignMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().textAlign,
              title: Text(textAlignMap.values.toList()[index]),
              onChanged: (String? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().changeTextAlign(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
