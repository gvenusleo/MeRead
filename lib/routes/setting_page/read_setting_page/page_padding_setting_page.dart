import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class PagePaddingSettingPage extends StatelessWidget {
  const PagePaddingSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
