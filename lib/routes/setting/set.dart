import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../routes/setting/about.dart';
import '../../states/state.dart';
import '../../utils/key.dart';
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
  final TextEditingController _defaultCategoryController =
      TextEditingController();
  int defaultOpenType = 0;
  int feedMaxSaveCount = 50;
  bool fullContent = false;
  bool allowDuplicate = false;

  Future<void> initData() async {
    final int size = await getFontSize();
    final double height = await getLineheight();
    final int padding = await getPagePadding();
    final String align = await getTextAlign();
    final String defaultCategory = await getDefaultCategory();
    final int openType = await getDefaultOpenType();
    final int maxSaveCount = await getFeedMaxSaveCount();
    final bool full = await getFullText();
    final bool allowDup = await getAllowDuplicate();
    setState(() {
      fontSize = size;
      lineheight = height;
      pagePadding = padding;
      textAlign = align;
      _defaultCategoryController.text = defaultCategory;
      defaultOpenType = openType;
      feedMaxSaveCount = maxSaveCount;
      fullContent = full;
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
        title: const Text(
          '设置',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        children: [
          // TODO：语言设置
          ListTile(
            title: const Text('颜色主题'),
            trailing: DropdownButton(
              value: Provider.of<ThemeModel>(context).themeIndex,
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text('浅色'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('深色'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('跟随系统'),
                ),
              ],
              onChanged: (int? value) {
                context.read<ThemeModel>().setTheme(value!);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('字体大小'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (fontSize > 14) {
                      setState(() {
                        fontSize = fontSize - 1;
                      });
                      await setFontSize(fontSize);
                    }
                  },
                ),
                Text(fontSize.toString()),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (fontSize < 24) {
                      setState(() {
                        fontSize = fontSize + 1;
                      });
                      await setFontSize(fontSize);
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('行间距'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (lineheight > 1.0) {
                      setState(() {
                        lineheight = lineheight - 0.1;
                      });
                      await setLineheight(lineheight);
                    }
                  },
                ),
                Text(lineheight.toStringAsFixed(1)),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (lineheight < 3.0) {
                      setState(() {
                        lineheight = lineheight + 0.1;
                      });
                      await setLineheight(lineheight);
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('页面边距'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (pagePadding > 0) {
                      setState(() {
                        pagePadding = pagePadding - 2;
                      });
                      await setPagePadding(pagePadding);
                    }
                  },
                ),
                Text(pagePadding.toString()),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (pagePadding < 36) {
                      setState(() {
                        pagePadding = pagePadding + 2;
                      });
                      await setPagePadding(pagePadding);
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('文字对齐'),
            trailing: DropdownButton(
              value: textAlign,
              items: [
                DropdownMenuItem(
                  value: 'left',
                  child: Text(
                    '左对齐',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'right',
                  child: Text(
                    '右对齐',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'justify',
                  child: Text(
                    '两端对齐',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
              ],
              onChanged: (value) async {
                setState(() {
                  textAlign = value!;
                });
                await setTextAlign(value!);
              },
            ),
          ),
          ListTile(
            title: const Text('自定义 CSS'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const CustomCssPage(),
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _defaultCategoryController,
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
              decoration: const InputDecoration(
                labelText: '订阅源默认分类名',
              ),
              onFieldSubmitted: (String value) async {
                await setDefalutCategory(value);
              },
            ),
          ),
          ListTile(
            title: const Text('文章默认打开方式'),
            trailing: DropdownButton(
              value: defaultOpenType,
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text('阅读器'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('内置标签页'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('系统浏览器'),
                ),
              ],
              onChanged: (int? value) async {
                setState(() {
                  defaultOpenType = value!;
                });
                await setDefaultOpenType(value!);
              },
            ),
          ),
          ListTile(
            title: const Text('每个订阅源最大保存数'),
            trailing: DropdownButton<int>(
              value: feedMaxSaveCount,
              items: [
                DropdownMenuItem(
                  value: 50,
                  child: Text(
                    '50',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 100,
                  child: Text(
                    '100',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 300,
                  child: Text(
                    '300',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 500,
                  child: Text(
                    '500',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
              ],
              onChanged: (int? value) async {
                if (value != null) {
                  setState(() {
                    feedMaxSaveCount = value;
                  });
                  await setFeedMaxSaveCount(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('默认获取全文'),
            trailing: Switch(
              value: fullContent,
              onChanged: (bool value) async {
                setState(() {
                  fullContent = value;
                });
                await setFullText(value);
              },
            ),
          ),
          ListTile(
            title: const Text('允许文章重复'),
            trailing: Switch(
              value: allowDuplicate,
              onChanged: (bool value) async {
                setState(() {
                  allowDuplicate = value;
                });
                await setAllowDuplicate(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('导入 OPML'),
            trailing: const Icon(Icons.chevron_right),
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
                    content: Text(
                      '开始后台导入',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
                final int failCount = await parseOpml(result);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      failCount == 0 ? '导入成功' : '$failCount 个订阅源导入失败',
                      textAlign: TextAlign.center,
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('导出 OPML'),
            trailing: const Icon(Icons.chevron_right),
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
          const Divider(),
          ListTile(
            title: const Text(
              '关于应用',
            ),
            trailing: const Icon(Icons.chevron_right),
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
