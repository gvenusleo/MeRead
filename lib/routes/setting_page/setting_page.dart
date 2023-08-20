import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meread/global/global.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:meread/routes/setting_page/about_page/about_page.dart';
import 'package:meread/routes/setting_page/block_setting_page/block_setting_page.dart';
import 'package:meread/routes/setting_page/dynamic_color_setting_page/dynamic_color_setting_page.dart';
import 'package:meread/routes/setting_page/font_setting_page/font_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/read_setting_page.dart';
import 'package:meread/routes/setting_page/text_scale_factor_setting_page/text_scale_factor_setting_page.dart';
import 'package:meread/routes/setting_page/theme_setting_page/theme_setting_page.dart';
import 'package:meread/utils/parse.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const ListTileGroupTitle(title: '个性化'),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('主题颜色'),
              subtitle: Text(
                [
                  '浅色模式',
                  '深色模式',
                  '跟随系统',
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
              title: const Text('动态取色'),
              subtitle: Text(
                  context.watch<ThemeProvider>().isDynamicColor ? '开启' : '关闭'),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const DynamicColorSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.font_download_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('全局字体'),
              subtitle: Text(
                context.watch<ThemeProvider>().themeFont.split('.').first,
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
              title: const Text('全局缩放'),
              subtitle: Text(
                {
                      0.8: '最小',
                      0.9: '较小',
                      1.0: '适中',
                      1.1: '较大',
                      1.2: '最大',
                    }[context.watch<ThemeProvider>().textScaleFactor] ??
                    '适中',
              ),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return TextScaleFactorSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('阅读页面'),
              subtitle: const Text('自定义文章阅读页面'),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const ReadSettingPage();
                }));
              },
            ),
            const ListTileGroupTitle(title: '数据管理'),
            ListTile(
              leading: const Icon(Icons.app_blocking_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('屏蔽规则'),
              subtitle: const Text('设置文章屏蔽规则'),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const BlockSettingPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('导入 OPML'),
              subtitle: const Text('从 OPML 文件导入订阅源'),
              onTap: importOPML,
            ),
            ListTile(
              leading: const Icon(Icons.file_upload_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('导出 OPML'),
              subtitle: const Text('将订阅源导出为 OPML 文件'),
              onTap: exportOPML,
            ),
            const ListTileGroupTitle(title: '其他'),
            ListTile(
              leading: const Icon(Icons.update_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('检查更新'),
              subtitle: const Text('获取应用最新版本'),
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('正在检查更新……'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(label: '确定', onPressed: () {}),
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
                        content: const Text('已是最新版本'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(label: '确定', onPressed: () {}),
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('检查更新失败'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(label: '确定', onPressed: () {}),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.android_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('关于应用'),
              subtitle: const Text('联系作者与开源地址'),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const AboutPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('开源许可'),
              subtitle: const Text('查看开源许可证'),
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'MeRead 悦读',
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
                applicationLegalese: '© 2022 - 2023 悦读. All Rights Reserved',
              ),
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
      type: FileType.custom,
      allowedExtensions: ['opml', 'xml'],
    );
    if (result != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('开始后台导入'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
      final int failCount = await parseOpml(result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failCount == 0 ? '导入成功' : '$failCount 个订阅源导入失败',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
    }
  }

  // 导出 OPML 文件
  Future<void> exportOPML() async {
    String opmlStr = await exportOpml();
    // opmlStr 字符串写入 feeds.opml 文件并分享，分享后删除文件
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/feeds-from-MeReader.xml');
    await file.writeAsString(opmlStr);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: '分享 OPML 文件',
    ).then((value) {
      if (value.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('导出成功'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(label: '确定', onPressed: () {}),
          ),
        );
      }
    });
    await file.delete();
  }
}
