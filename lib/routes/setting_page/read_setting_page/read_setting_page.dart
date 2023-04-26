import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:meread/routes/setting_page/read_setting_page/font_size_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/line_height_setting_page.dart';
import 'package:meread/routes/setting_page/read_setting_page/page_padding_setting_page.dart';
import 'package:provider/provider.dart';

import 'custom_css_page.dart';
import 'text_align_setting_page.dart';

class ReadSettingPage extends StatelessWidget {
  const ReadSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('阅读页面'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.text_increase_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('字体大小'),
              subtitle: Text(
                {
                      14: '最小',
                      16: '较小',
                      18: '适中',
                      20: '较大',
                      22: '最大',
                    }[context.watch<ReadPageProvider>().fontSize] ??
                    '适中',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FontSizeSettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.vertical_distribute_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('行高'),
              subtitle: Text(
                {
                      1.0: '最小',
                      1.2: '较小',
                      1.5: '适中',
                      1.8: '较大',
                      2.0: '最大',
                    }[context.watch<ReadPageProvider>().lineHeight] ??
                    '适中',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => LineHeightSettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.space_bar_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('页面边距'),
              subtitle: Text(
                {
                      0: '最小',
                      9: '较小',
                      18: '适中',
                      27: '较大',
                      36: '最大',
                    }[context.watch<ReadPageProvider>().pagePadding] ??
                    '适中',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PagePaddingSettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_align_left_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('文字对齐'),
              subtitle: Text(
                {
                      'left': '左对齐',
                      'right': '右对齐',
                      'center': '居中对齐',
                      'justify': '两端对齐',
                    }[context.watch<ReadPageProvider>().textAlign] ??
                    '两端对齐',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TextAlignSettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.code_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('自定义 CSS'),
              subtitle: const Text('阅读页面 CSS 样式'),
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
