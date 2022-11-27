import 'package:flutter/material.dart';

import '../../utils/key.dart';

class ApiSetPage extends StatefulWidget {
  const ApiSetPage({Key? key}) : super(key: key);

  @override
  ApiSetPageState createState() => ApiSetPageState();
}

class ApiSetPageState extends State<ApiSetPage> {
  final TextEditingController _flomoApiKeyController = TextEditingController();
  final TextEditingController _flomoTagController = TextEditingController();
  bool useFlomo = false;
  bool useCategoryAsTag = false;
  bool savePostLink = false;

  // 初始化数据
  Future<void> initData() async {
    final String api = await getFlomoApiKey();
    final String tag = await getFlomoTag();
    final bool category = await getUseCategoryAsTag();
    final bool save = await getSavePostLink();
    final bool use = await getUseFlomo();
    setState(() {
      _flomoApiKeyController.text = api;
      _flomoTagController.text = tag;
      useCategoryAsTag = category;
      savePostLink = save;
      useFlomo = use;
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
          '接口配置',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('启用 flomo 接口'),
              trailing: Switch(
                value: useFlomo,
                onChanged: (bool value) async {
                  setState(() {
                    useFlomo = value;
                  });
                  await setUseFlomo(value);
                },
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            TextFormField(
              enabled: useFlomo,
              controller: _flomoApiKeyController,
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
              decoration: const InputDecoration(
                labelText: '输入 flomo API',
              ),
              onFieldSubmitted: (String value) async {
                await setFlomoApiKey(value);
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              enabled: useFlomo,
              controller: _flomoTagController,
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
              decoration: const InputDecoration(
                labelText: '输入 flomo 标签',
              ),
              onFieldSubmitted: (String value) async {
                await setFlomoTag(value);
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('使用订阅源分类作为默认标签'),
              trailing: Switch(
                value: useCategoryAsTag,
                onChanged: (bool value) async {
                  if (useFlomo) {
                    setState(() {
                      useCategoryAsTag = value;
                    });
                    await setUseCategoryAsTag(value);
                  }
                },
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('同时保存文章链接'),
              trailing: Switch(
                value: savePostLink,
                onChanged: (bool value) async {
                  if (useFlomo) {
                    setState(() {
                      savePostLink = value;
                    });
                    await setSavePostLink(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
