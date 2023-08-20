import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class TextAlignSettingPage extends StatelessWidget {
  const TextAlignSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
