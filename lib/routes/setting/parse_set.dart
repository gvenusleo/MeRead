import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meread/utils/key.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:meread/utils/parse.dart';

class ParseSetPage extends StatefulWidget {
  const ParseSetPage({Key? key}) : super(key: key);

  @override
  ParseSetPageState createState() => ParseSetPageState();
}

class ParseSetPageState extends State<ParseSetPage> {
  final TextEditingController _defaultCategoryController =
      TextEditingController();
  int defaultOpenType = 0;
  int feedMaxSaveCount = 50;

  Future<void> initData() async {
    final String defaultCategory = await getDefaultCategory();
    final int openType = await getDefaultOpenType();
    final int maxSaveCount = await getFeedMaxSaveCount();
    setState(() {
      _defaultCategoryController.text = defaultCategory;
      defaultOpenType = openType;
      feedMaxSaveCount = maxSaveCount;
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
          '解析设置',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: ListView(
          children: [
            TextFormField(
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
            const SizedBox(height: 12),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
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
              contentPadding: const EdgeInsets.all(0),
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
              contentPadding: const EdgeInsets.all(0),
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
              contentPadding: const EdgeInsets.all(0),
              title: const Text('导出 OPML'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                String opmlStr = await exportOpml();
                // opmlStr 字符串写入 feeds.opml 文件并分享，分享后删除文件
                final Directory tempDir = await getTemporaryDirectory();
                final File file =
                    File('${tempDir.path}/feeds-from-MeReader.xml');
                await file.writeAsString(opmlStr);
                await Share.shareXFiles(
                  [XFile(file.path)],
                  text: '分享 OPML 文件',
                );
                await file.delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
