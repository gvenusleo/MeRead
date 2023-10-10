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
import 'package:meread/routes/setting_page/proxy_setting_page/proxy_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/read_setting_page.dart';
import 'package:meread/routes/setting_page/refresh_rate_setting_page/refresh_rate_setting_page.dart';
import 'package:meread/routes/setting_page/refresh_setting_page/refresh_setting_page.dart';
import 'package:meread/routes/setting_page/text_scale_factor_setting_page/text_scale_factor_setting_page.dart';
import 'package:meread/routes/setting_page/theme_setting_page/theme_setting_page.dart';
import 'package:meread/utils/notification_util.dart';
import 'package:meread/utils/open_url_util.dart';
import 'package:meread/utils/opml_util.dart';
import 'package:meread/widgets/list_tile_group_title.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Widget? rightWidget;
  double leftWidth = 400;
  double rightWidth = 400;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return buildSettingScaffold();
    } else {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: leftWidth,
              child: buildSettingScaffold(),
            ),
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  leftWidth += details.delta.dx;
                  if (leftWidth < 200) {
                    leftWidth = 200;
                  } else if (leftWidth > 800) {
                    leftWidth = 800;
                  }
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: SizedBox(
                  width: 8,
                  child: Center(
                    child: VerticalDivider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            buildRightWidget(),
            if (rightWidget != null)
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    rightWidth += details.delta.dx;
                    if (rightWidth < 200) {
                      rightWidth = 200;
                    } else if (rightWidth > 800) {
                      rightWidth = 800;
                    }
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: SizedBox(
                    width: 8,
                    child: Center(
                      child: VerticalDivider(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget buildRightWidget() {
    return SizedBox(
      width: rightWidth,
      child: rightWidget ?? const SizedBox.shrink(),
    );
  }

  Widget buildSettingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ListTileGroupTitle(
              title: AppLocalizations.of(context)!.personalization,
            ),
            /* 语言设置 */
            ListTile(
              leading: const Icon(Icons.translate_outlined),
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
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const LanguageSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget = const LanguageSettingPage(needLeading: false);
                  });
                }
              },
            ),
            /* 颜色主题设置 */
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: Text(AppLocalizations.of(context)!.themeMode),
              subtitle: Text(
                [
                  AppLocalizations.of(context)!.lightMode,
                  AppLocalizations.of(context)!.darkMode,
                  AppLocalizations.of(context)!.followSystem,
                ][context.watch<ThemeProvider>().themeIndex],
              ),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const ThemeSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget = const ThemeSettingPage(needLeading: false);
                  });
                }
              },
            ),
            /* 动态取色设置 */
            ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: Text(AppLocalizations.of(context)!.dynamicColor),
              subtitle: Text(context.watch<ThemeProvider>().isDynamicColor
                  ? AppLocalizations.of(context)!.open
                  : AppLocalizations.of(context)!.close),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const DynamicColorSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget =
                        const DynamicColorSettingPage(needLeading: false);
                  });
                }
              },
            ),
            /* 全局字体设置 */
            ListTile(
              leading: const Icon(Icons.font_download_outlined),
              title: Text(AppLocalizations.of(context)!.globalFont),
              subtitle: Text(
                context.watch<ThemeProvider>().themeFont.split('.').first ==
                        '默认字体'
                    ? AppLocalizations.of(context)!.defaultFont
                    : context.watch<ThemeProvider>().themeFont.split('.').first,
              ),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const FontSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget = const FontSettingPage(needLeading: false);
                  });
                }
              },
            ),
            /* 全局缩放设置 */
            ListTile(
              leading: const Icon(Icons.text_fields_outlined),
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
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const TextScaleFactorSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget =
                        const TextScaleFactorSettingPage(needLeading: false);
                  });
                }
              },
            ),
            /* 屏幕帧率 */
            ListTile(
              leading: const Icon(Icons.display_settings_outlined),
              title: Text(AppLocalizations.of(context)!.screenRefreshRate),
              subtitle:
                  Text(AppLocalizations.of(context)!.screenRefreshRateInfo),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const RefreshRateSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget =
                        const RefreshRateSettingPage(needLeading: false);
                  });
                }
              },
            ),
            /* 阅读页面配置设置 */
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(AppLocalizations.of(context)!.readingPage),
              subtitle: Text(
                AppLocalizations.of(context)!.customPostReadingPage,
              ),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const ReadSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget = const ReadSettingPage(needLeading: false);
                  });
                }
              },
            ),
            ListTileGroupTitle(
              title: AppLocalizations.of(context)!.parseSettings,
            ),
            /* 刷新设置 */
            ListTile(
              leading: const Icon(Icons.refresh_outlined),
              title: Text(AppLocalizations.of(context)!.refreshSettings),
              subtitle: Text(
                AppLocalizations.of(context)!.setRefreshRules,
              ),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const RefreshSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget = const RefreshSettingPage(needLeading: false);
                  });
                }
              },
            ),
            /* 屏蔽词设置 */
            ListTile(
              leading: const Icon(Icons.app_blocking_outlined),
              title: Text(AppLocalizations.of(context)!.blockRules),
              subtitle: Text(
                AppLocalizations.of(context)!.setPostBlockRule,
              ),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const BlockSettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget = const BlockSettingPage(needLeading: false);
                  });
                }
              },
            ),
            /* 代理设置 */
            ListTile(
              leading: const Icon(Icons.smart_button_outlined),
              title: Text(AppLocalizations.of(context)!.proxySettings),
              subtitle: Text(
                AppLocalizations.of(context)!.setProxyAddress,
              ),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const ProxySettingPage();
                  }));
                } else {
                  setState(() {
                    rightWidget = const ProxySettingPage(needLeading: false);
                  });
                }
              },
            ),
            ListTileGroupTitle(
              title: AppLocalizations.of(context)!.dataManagement,
            ),

            /* 导入 OPML 文件 */
            ListTile(
              leading: const Icon(Icons.file_download_outlined),
              title: Text(AppLocalizations.of(context)!.importOPML),
              subtitle: Text(
                AppLocalizations.of(context)!.importFeedsFromOPML,
              ),
              onTap: importOPML,
            ),
            /* 导出 OPML 文件 */
            ListTile(
              leading: const Icon(Icons.file_upload_outlined),
              title: Text(AppLocalizations.of(context)!.exportOPML),
              subtitle: Text(
                AppLocalizations.of(context)!.exportFeedsToOPML,
              ),
              onTap: exportOPML,
            ),
            ListTileGroupTitle(title: AppLocalizations.of(context)!.others),
            /* 检查更新 */
            ListTile(
              leading: const Icon(Icons.update_outlined),
              title: Text(AppLocalizations.of(context)!.checkForUpdates),
              subtitle: Text(AppLocalizations.of(context)!.getLatestVersion),
              onTap: checkUpdate,
            ),
            /* 关于 */
            ListTile(
              leading: const Icon(Icons.android_outlined),
              title: Text(AppLocalizations.of(context)!.about),
              subtitle:
                  Text(AppLocalizations.of(context)!.contactAndOpenSource),
              onTap: () {
                if (Platform.isAndroid) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const AboutPage();
                  }));
                } else {
                  setState(() {
                    rightWidget = const AboutPage(needLeading: false);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 导入 OPML 文件
  Future<void> importOPML() async {
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
              icon: const Icon(Icons.error_outline_outlined),
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
      showToastOrSnackBar(
        context,
        AppLocalizations.of(context)!.startBackgroundImport,
      );
      final int failCount = await parseOpml(result);
      if (!mounted) return;
      showToastOrSnackBar(
        context,
        failCount == 0
            ? AppLocalizations.of(context)!.importSuccess
            : AppLocalizations.of(context)!.importFailedForFeeds(failCount),
      );
    }
  }

  /// 导出 OPML 文件
  Future<void> exportOPML() async {
    final String successText = AppLocalizations.of(context)!.shareOPMLFile;
    String opmlStr = await exportOpmlBase();
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/feeds-from-MeRead.xml');
    await file.writeAsString(opmlStr);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: successText,
    ).then((value) {
      if (value.status == ShareResultStatus.success) {
        showToastOrSnackBar(
          context,
          AppLocalizations.of(context)!.exportSuccess,
        );
      }
    });
    await file.delete();
  }

  /// 检查更新
  Future<void> checkUpdate() async {
    showToastOrSnackBar(
      context,
      AppLocalizations.of(context)!.checkingForUpdates,
    );
    try {
      /* 通过访问 https://github.com/gvenusleo/MeRead/releases/latest 获取最新版本号 */
      final Dio dio = Dio();
      final response = await dio.get(
        'https://github.com/gvenusleo/MeRead/releases/latest',
      );
      /* 获取网页 title */
      final String title =
          response.data.split('<title>')[1].split('</title>')[0];
      final String latestVersion = title.split(' ')[1];
      if (latestVersion == applicationVersion) {
        if (!mounted) return;
        showToastOrSnackBar(
          context,
          AppLocalizations.of(context)!.alreadyLatestVersion,
        );
      } else {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.system_update_rounded),
              title: Text(AppLocalizations.of(context)!.newVersionAvailable),
              content: Text(AppLocalizations.of(context)!.downloadNow),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () {
                    openUrl(
                      "https://github.com/gvenusleo/MeRead/releases/latest",
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
      showToastOrSnackBar(
        context,
        AppLocalizations.of(context)!.failedToCheckForUpdates,
      );
    }
  }
}
