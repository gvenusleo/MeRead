import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class PagePaddingSettingPage extends StatefulWidget {
  const PagePaddingSettingPage({Key? key}) : super(key: key);

  @override
  State<PagePaddingSettingPage> createState() => _PagePaddingSettingPageState();
}

class _PagePaddingSettingPageState extends State<PagePaddingSettingPage> {
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
    final Map<int, String> pagePaddingMap = {
      0: AppLocalizations.of(context)!.minimum,
      9: AppLocalizations.of(context)!.small,
      18: AppLocalizations.of(context)!.medium,
      27: AppLocalizations.of(context)!.large,
      36: AppLocalizations.of(context)!.maximum,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pagePadding),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: pagePaddingMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: pagePaddingMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().pagePadding,
              title: Text(pagePaddingMap.values.toList()[index]),
              onChanged: (int? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().changePagePadding(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
