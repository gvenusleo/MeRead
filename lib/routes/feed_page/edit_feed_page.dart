import 'package:flutter/material.dart';

import '../../models/feed.dart';
import '../../widgets/list_tile_group_title.dart';

class EditFeedPage extends StatefulWidget {
  const EditFeedPage({Key? key, required this.feed}) : super(key: key);

  final Feed feed;

  @override
  EditFeedPageState createState() => EditFeedPageState();
}

class EditFeedPageState extends State<EditFeedPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final List<String> openTypeList = [
    '在应用内打开',
    '在内置标签页中打开',
    '在系统浏览器中打开',
  ];

  @override
  void initState() {
    super.initState();
    _urlController.text = widget.feed.url;
    _nameController.text = widget.feed.name;
    _categoryController.text = widget.feed.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑订阅'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '订阅源地址',
                  enabled: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '订阅源名称',
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '订阅源分类',
                ),
              ),
            ),
            const SizedBox(height: 18),
            SwitchListTile(
              value: widget.feed.fullText == 1,
              title: const Text('是否获取全文'),
              onChanged: (bool value) {
                setState(() {
                  widget.feed.fullText = value ? 1 : 0;
                });
              },
            ),
            const ListTileGroupTitle(title: '文章打开方式'),
            ...openTypeList.map(
              (e) {
                return RadioListTile(
                  value: openTypeList.indexOf(e),
                  groupValue: widget.feed.openType,
                  title: Text(e),
                  onChanged: (int? value) {
                    setState(() {
                      widget.feed.openType = value!;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 18),
            // 取消与保存
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('取消'),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () async {
                    widget.feed.name = _nameController.text;
                    widget.feed.category = _categoryController.text;
                    // 如果 feed 不存在，添加 feed，否则更新 feed
                    if (await Feed.isExist(widget.feed.url)) {
                      await widget.feed.updateToDb();
                      await widget.feed.updatePostFeedName();
                      await widget.feed.updatePostsOpenType();
                    } else {
                      await widget.feed.insertToDb();
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('保存'),
                ),
                const SizedBox(width: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
