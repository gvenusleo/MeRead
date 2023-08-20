import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:meread/routes/setting_page/read_setting_page/custom_css_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/font_size_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/line_height_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/page_padding_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/text_align_setting_page.dart';
import 'package:provider/provider.dart';

class ReadSettingPage extends StatelessWidget {
  const ReadSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.readingPage),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.text_increase_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.fontSize),
              subtitle: Text(
                {
                      14: AppLocalizations.of(context)!.minimum,
                      16: AppLocalizations.of(context)!.small,
                      18: AppLocalizations.of(context)!.medium,
                      20: AppLocalizations.of(context)!.large,
                      22: AppLocalizations.of(context)!.maximum,
                    }[context.watch<ReadPageProvider>().fontSize] ??
                    AppLocalizations.of(context)!.medium,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const FontSizeSettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.vertical_distribute_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.lineHeight),
              subtitle: Text(
                {
                      1.0: AppLocalizations.of(context)!.minimum,
                      1.2: AppLocalizations.of(context)!.small,
                      1.5: AppLocalizations.of(context)!.medium,
                      1.8: AppLocalizations.of(context)!.large,
                      2.0: AppLocalizations.of(context)!.maximum,
                    }[context.watch<ReadPageProvider>().lineHeight] ??
                    AppLocalizations.of(context)!.medium,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const LineHeightSettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.space_bar_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.pagePadding),
              subtitle: Text(
                {
                      0: AppLocalizations.of(context)!.minimum,
                      9: AppLocalizations.of(context)!.small,
                      18: AppLocalizations.of(context)!.medium,
                      27: AppLocalizations.of(context)!.large,
                      36: AppLocalizations.of(context)!.maximum,
                    }[context.watch<ReadPageProvider>().pagePadding] ??
                    AppLocalizations.of(context)!.medium,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const PagePaddingSettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_align_left_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.textAlignment),
              subtitle: Text(
                {
                      'left': AppLocalizations.of(context)!.leftAlignment,
                      'right': AppLocalizations.of(context)!.rightAlignment,
                      'center': AppLocalizations.of(context)!.centerAlignment,
                      'justify': AppLocalizations.of(context)!.justifyAlignment,
                    }[context.watch<ReadPageProvider>().textAlign] ??
                    AppLocalizations.of(context)!.justifyAlignment,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const TextAlignSettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.code_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.customCSS),
              subtitle: Text(AppLocalizations.of(context)!.readingPageCSSStyle),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const CustomCssPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
