import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../routes/setting/about.dart';
import '../../states/theme_state.dart';
import '../../data/setting.dart';
import '../../utils/parse.dart';
import 'custom_css.dart';

class SetPage extends StatefulWidget {
  const SetPage({super.key});

  @override
  State<SetPage> createState() => _SetPageState();
}

class _SetPageState extends State<SetPage> {
  int fontSize = 18;
  double lineheight = 1.5;
  int pagePadding = 18;
  String textAlign = 'justify';
  int feedMaxSaveCount = 50;
  bool allowDuplicate = false;

  Future<void> initData() async {
    final int size = await getFontSize();
    final double height = await getLineheight();
    final int padding = await getPagePadding();
    final String align = await getTextAlign();
    final int maxSaveCount = await getFeedMaxSaveCount();
    final bool allowDup = await getAllowDuplicate();
    setState(() {
      fontSize = size;
      lineheight = height;
      pagePadding = padding;
      textAlign = align;
      feedMaxSaveCount = maxSaveCount;
      allowDuplicate = allowDup;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 48),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Text(
              '主题外观',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('颜色主题'),
            subtitle: Text(
              Provider.of<ThemeModel>(context).themeIndex == 0
                  ? '浅色模式'
                  : Provider.of<ThemeModel>(context).themeIndex == 1
                      ? '深色模式'
                      : '跟随系统',
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('选择颜色主题'),
                  contentPadding: const EdgeInsets.only(top: 12, bottom: 24),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                        value: 0,
                        groupValue: Provider.of<ThemeModel>(context).themeIndex,
                        onChanged: (int? value) {
                          context.read<ThemeModel>().setTheme(value!);
                          Navigator.pop(context);
                        },
                        title: const Text('浅色模式'),
                      ),
                      RadioListTile(
                        value: 1,
                        groupValue: Provider.of<ThemeModel>(context).themeIndex,
                        onChanged: (int? value) {
                          context.read<ThemeModel>().setTheme(value!);
                          Navigator.pop(context);
                        },
                        title: const Text('深色模式'),
                      ),
                      RadioListTile(
                        value: 2,
                        groupValue: Provider.of<ThemeModel>(context).themeIndex,
                        onChanged: (int? value) {
                          context.read<ThemeModel>().setTheme(value!);
                          Navigator.pop(context);
                        },
                        title: const Text('跟随系统'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.text_increase_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('字体大小'),
            subtitle: Text(fontSize.toString()),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setFontSizeState) {
                    return AlertDialog(
                      title: const Text('选择字体大小'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: fontSize.toDouble(),
                            min: 14,
                            max: 24,
                            divisions: 10,
                            label: fontSize.toString(),
                            onChanged: (double value) async {
                              setFontSizeState(() {
                                fontSize = value.toInt();
                              });
                              setState(() {
                                fontSize = value.toInt();
                              });
                              await setFontSize(fontSize);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.vertical_distribute_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('行间距'),
            subtitle: Text(lineheight.toStringAsFixed(1)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setLineheightState) {
                    return AlertDialog(
                      title: const Text('选择行间距'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: lineheight,
                            min: 1.0,
                            max: 3.0,
                            divisions: 20,
                            label: lineheight.toStringAsFixed(1),
                            onChanged: (double value) async {
                              setLineheightState(() {
                                lineheight = value;
                              });
                              setState(() {
                                lineheight = value;
                              });
                              await setLineheight(lineheight);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.space_bar_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('页面边距'),
            subtitle: Text(pagePadding.toString()),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setPagePaddingState) {
                    return AlertDialog(
                      title: const Text('选择页面边距'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: pagePadding.toDouble(),
                            min: 0,
                            max: 36,
                            divisions: 18,
                            label: pagePadding.toString(),
                            onChanged: (double value) async {
                              setPagePaddingState(() {
                                pagePadding = value.toInt();
                              });
                              setState(() {
                                pagePadding = value.toInt();
                              });
                              await setPagePadding(pagePadding);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_align_left_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('文字对齐'),
            subtitle: Text(
              textAlign == 'left'
                  ? '左对齐'
                  : textAlign == 'right'
                      ? '右对齐'
                      : '两端对齐',
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('选择文字对齐方式'),
                  contentPadding: const EdgeInsets.only(top: 12, bottom: 24),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                        value: 'left',
                        groupValue: textAlign,
                        onChanged: (String? value) async {
                          setState(() {
                            textAlign = value!;
                          });
                          await setTextAlign(textAlign);
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                        title: const Text('左对齐'),
                      ),
                      RadioListTile(
                        value: 'right',
                        groupValue: textAlign,
                        onChanged: (String? value) async {
                          setState(() {
                            textAlign = value!;
                          });
                          await setTextAlign(textAlign);
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                        title: const Text('右对齐'),
                      ),
                      RadioListTile(
                        value: 'justify',
                        groupValue: textAlign,
                        onChanged: (String? value) async {
                          setState(() {
                            textAlign = value!;
                          });
                          await setTextAlign(textAlign);
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                        title: const Text('两端对齐'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.code_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('自定义 CSS'),
            subtitle: const Text('自定义阅读页面 CSS 样式'),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const CustomCssPage(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Text(
              '数据管理',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('订阅源文章最大保存数量'),
            subtitle: Text(
              feedMaxSaveCount.toString(),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setFeedMaxSaveCountState) {
                    return AlertDialog(
                      contentPadding:
                          const EdgeInsets.only(top: 12, bottom: 24),
                      title: const Text('选择订阅源文章最大保存数量'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile(
                            value: 50,
                            groupValue: feedMaxSaveCount,
                            onChanged: (int? value) async {
                              setFeedMaxSaveCountState(() {
                                feedMaxSaveCount = value!;
                              });
                              setState(() {
                                feedMaxSaveCount = value!;
                              });
                              await setFeedMaxSaveCount(feedMaxSaveCount);
                              if (!mounted) return;
                              Navigator.pop(context);
                            },
                            title: const Text('50'),
                          ),
                          RadioListTile(
                            value: 100,
                            groupValue: feedMaxSaveCount,
                            onChanged: (int? value) async {
                              setFeedMaxSaveCountState(() {
                                feedMaxSaveCount = value!;
                              });
                              setState(() {
                                feedMaxSaveCount = value!;
                              });
                              await setFeedMaxSaveCount(feedMaxSaveCount);
                              if (!mounted) return;
                              Navigator.pop(context);
                            },
                            title: const Text('100'),
                          ),
                          RadioListTile(
                            value: 500,
                            groupValue: feedMaxSaveCount,
                            onChanged: (int? value) async {
                              setFeedMaxSaveCountState(() {
                                feedMaxSaveCount = value!;
                              });
                              setState(() {
                                feedMaxSaveCount = value!;
                              });
                              await setFeedMaxSaveCount(feedMaxSaveCount);
                              if (!mounted) return;
                              Navigator.pop(context);
                            },
                            title: const Text('500'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // ListTile(
          //   title: const Text('允许文章重复'),
          //   trailing: Switch(
          //     value: allowDuplicate,
          //     onChanged: (bool value) async {
          //       setState(() {
          //         allowDuplicate = value;
          //       });
          //       await setAllowDuplicate(value);
          //     },
          //   ),
          // ),
          SwitchListTile(
            secondary: Icon(
              Icons.copy_outlined,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            title: const Text('允许文章重复'),
            subtitle: const Text('开启后将不剔除重复文章'),
            value: allowDuplicate,
            onChanged: (bool value) async {
              setState(() {
                allowDuplicate = value;
              });
              await setAllowDuplicate(value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('导入 OPML'),
            subtitle: const Text('将订阅源导出为 OPML 文件'),
            onTap: () async {
              // 打开文件选择器
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['opml', 'xml'],
              );
              if (result != null) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('开始后台导入'),
                    showCloseIcon: true,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
                final int failCount = await parseOpml(result);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      failCount == 0 ? '导入成功' : '$failCount 个订阅源导入失败',
                    ),
                    showCloseIcon: true,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text('导出 OPML'),
            subtitle: const Text('从 OPML 文件导入订阅源'),
            onTap: () async {
              String opmlStr = await exportOpml();
              // opmlStr 字符串写入 feeds.opml 文件并分享，分享后删除文件
              final Directory tempDir = await getTemporaryDirectory();
              final File file = File('${tempDir.path}/feeds-from-MeReader.xml');
              await file.writeAsString(opmlStr);
              await Share.shareXFiles(
                [XFile(file.path)],
                text: '分享 OPML 文件',
              );
              await file.delete();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Text(
              '其他',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.android_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: const Text(
              '关于应用',
            ),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return const AboutPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
