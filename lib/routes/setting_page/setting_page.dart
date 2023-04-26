import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meread/routes/setting_page/font_setting_page/font_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/read_setting_page.dart';
import 'package:meread/routes/setting_page/theme_setting_page/theme_setting_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../provider/theme_provider.dart';
import '../../utils/parse.dart';
import '../../widgets/list_tile_group_title.dart';
import 'about_page/about_page.dart';

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
              leading: const Icon(Icons.font_download_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('应用字体'),
              subtitle: const Text('自定义应用字体'),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return const FontSettingPage();
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
