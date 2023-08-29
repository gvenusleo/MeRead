import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/global/global.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:meread/routes/setting_page/about_page/about_page.dart';
import 'package:meread/routes/setting_page/block_setting_page/block_setting_page.dart';
import 'package:meread/routes/setting_page/dynamic_color_setting_page/dynamic_color_setting_page.dart';
import 'package:meread/routes/setting_page/font_setting_page/font_setting_page.dart';
import 'package:meread/routes/setting_page/language_setting_page/language_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/read_setting_page.dart';
import 'package:meread/routes/setting_page/text_scale_factor_setting_page/text_scale_factor_setting_page.dart';
import 'package:meread/routes/setting_page/theme_setting_page/theme_setting_page.dart';
import 'package:meread/utils/parse.dart';
import 'package:meread/widgets/list_tile_group_title.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTileGroupTitle(
              title: AppLocalizations.of(context)!.personalization,
            ),
            ListTile(
              leading: const Icon(Icons.translate_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.languageSetting),
              subtitle: Text(
                {
                      'locale': AppLocalizations.of(context)!.systemLanguage,
                      'zh': '简体中文',
                      'en': 'English',
                    }[context.watch<ThemeProvider>().language] ??
                    AppLocalizations.of(context)!.systemLanguage,
              ),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const LanguageSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.themeMode),
              subtitle: Text(
                [
                  AppLocalizations.of(context)!.lightMode,
                  AppLocalizations.of(context)!.darkMode,
                  AppLocalizations.of(context)!.followSystem,
                ][context.watch<ThemeProvider>().themeIndex],
              ),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const ThemeSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.dynamicColor),
              subtitle: Text(context.watch<ThemeProvider>().isDynamicColor
                  ? AppLocalizations.of(context)!.open
                  : AppLocalizations.of(context)!.close),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const DynamicColorSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.font_download_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.globalFont),
              subtitle: Text(
                context.watch<ThemeProvider>().themeFont.split('.').first ==
                        '默认字体'
                    ? AppLocalizations.of(context)!.defaultFont
                    : context.watch<ThemeProvider>().themeFont.split('.').first,
              ),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const FontSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.globalScale),
              subtitle: Text(
                {
                      0.8: AppLocalizations.of(context)!.minimum,
                      0.9: AppLocalizations.of(context)!.small,
                      1.0: AppLocalizations.of(context)!.medium,
                      1.1: AppLocalizations.of(context)!.large,
                      1.2: AppLocalizations.of(context)!.maximum,
                    }[context.watch<ThemeProvider>().textScaleFactor] ??
                    AppLocalizations.of(context)!.medium,
              ),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const TextScaleFactorSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.readingPage),
              subtitle: Text(
                AppLocalizations.of(context)!.customPostReadingPage,
              ),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const ReadSettingPage();
                }));
              },
            ),
            ListTileGroupTitle(
              title: AppLocalizations.of(context)!.dataManagement,
            ),
            ListTile(
              leading: const Icon(Icons.app_blocking_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.blockRules),
              subtitle: Text(
                AppLocalizations.of(context)!.setPostBlockRule,
              ),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const BlockSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.importOPML),
              subtitle: Text(
                AppLocalizations.of(context)!.importFeedsFromOPML,
              ),
              onTap: importOPML,
            ),
            ListTile(
              leading: const Icon(Icons.file_upload_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.exportOPML),
              subtitle: Text(
                AppLocalizations.of(context)!.exportFeedsToOPML,
              ),
              onTap: exportOPML,
            ),
            ListTileGroupTitle(title: AppLocalizations.of(context)!.others),
            ListTile(
              leading: const Icon(Icons.update_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.checkForUpdates),
              subtitle: Text(AppLocalizations.of(context)!.getLatestVersion),
              onTap: checkUpdate,
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.openSourceLicenses),
              subtitle: Text(
                AppLocalizations.of(context)!.viewOpenSourceLicenses,
              ),
              onTap: () => showLicensePage(
                context: context,
                applicationName: AppLocalizations.of(context)!.meRead,
                applicationVersion: applicationVersion,
                applicationIcon: Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.only(bottom: 8, top: 8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                      image: AssetImage('assets/meread.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                applicationLegalese:
                    '© 2022 - 2023 ${AppLocalizations.of(context)!.meRead}. All Rights Reserved.',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.android_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: Text(AppLocalizations.of(context)!.about),
              subtitle:
                  Text(AppLocalizations.of(context)!.contactAndOpenSource),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const AboutPage();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }

  // 导入 OPML 文件
  Future<void> importOPML() async {
    // 打开文件选择器
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // file_picker 无法正确过滤 opml 格式文件
      // allowedExtensions: ['opml', 'xml'],
    );
    if (result != null) {
      if (result.files.first.extension != 'opml' &&
          result.files.first.extension != 'xml') {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.importFailed),
              content: Text(AppLocalizations.of(context)!.fileFormatError),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            );
          },
        );
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.startBackgroundImport),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.ok,
            onPressed: () {},
          ),
        ),
      );
      final int failCount = await parseOpml(result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failCount == 0
                ? AppLocalizations.of(context)!.importSuccess
                : AppLocalizations.of(context)!.importFailedForFeeds(failCount),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.ok,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  // 导出 OPML 文件
  Future<void> exportOPML() async {
    final String successText = AppLocalizations.of(context)!.shareOPMLFile;
    String opmlStr = await exportOpml();
    // opmlStr 字符串写入 feeds.opml 文件并分享，分享后删除文件
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/feeds-from-MeRead.xml');
    await file.writeAsString(opmlStr);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: successText,
    ).then((value) {
      if (value.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.exportSuccess),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
                label: AppLocalizations.of(context)!.ok, onPressed: () {}),
          ),
        );
      }
    });
    await file.delete();
  }

  // 检查更新
  Future<void> checkUpdate() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.checkingForUpdates),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.ok,
          onPressed: () {},
        ),
      ),
    );
    try {
      // 通过访问 https://github.com/gvenusleo/MeRead/releases/latest 获取最新版本号
      final Dio dio = Dio();
      final response = await dio.get(
        'https://github.com/gvenusleo/MeRead/releases/latest',
      );
      // 获取网页 title
      final String title =
          response.data.split('<title>')[1].split('</title>')[0];
      final String latestVersion = title.split(' ')[1];
      if (latestVersion == applicationVersion) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.alreadyLatestVersion),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.ok,
              onPressed: () {},
            ),
          ),
        );
      } else {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.newVersionAvailable),
              content: Text(AppLocalizations.of(context)!.downloadNow),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse(
                          'https://github.com/gvenusleo/MeRead/releases/latest'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.download),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedToCheckForUpdates),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.failedToCheckForUpdates,
            onPressed: () {},
          ),
        ),
      );
    }
  }
}
