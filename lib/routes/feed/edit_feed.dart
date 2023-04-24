import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../../models/feed.dart';

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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '订阅源地址',
                enabled: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '订阅源名称',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
            child: TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '订阅源分类',
              ),
            ),
          ),
          // 获取全文
          SwitchListTile(
            value: widget.feed.fullText == 1,
            title: const Text('是否获取全文'),
            onChanged: (bool value) {
              setState(() {
                widget.feed.fullText = value ? 1 : 0;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Text(
              '文章打开方式',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          RadioListTile(
            value: 0,
            groupValue: widget.feed.openType,
            title: const Text('在应用内打开'),
            onChanged: (int? value) {
              setState(() {
                widget.feed.openType = value!;
              });
            },
          ),
          RadioListTile(
            value: 1,
            groupValue: widget.feed.openType,
            title: const Text('在内置标签页中打开'),
            onChanged: (int? value) {
              setState(() {
                widget.feed.openType = value!;
              });
            },
          ),
          RadioListTile(
            value: 2,
            groupValue: widget.feed.openType,
            title: const Text('在系统浏览器中打开'),
            onChanged: (int? value) {
              setState(() {
                widget.feed.openType = value!;
              });
            },
          ),
          const SizedBox(height: 24),
          // 取消与保存
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonal(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
              const SizedBox(width: 24),
              FilledButton.tonal(
                onPressed: () async {
                  widget.feed.name = _nameController.text;
                  widget.feed.category = _categoryController.text;
                  // 如果 feed 不存在，添加 feed，否则更新 feed
                  if (await feedExist(widget.feed.url)) {
                    await updateFeed(widget.feed);
                    await updatePostFeedName(widget.feed.id!, widget.feed.name);
                    await updateFeedPostsOpenType(
                        widget.feed.id!, widget.feed.openType);
                  } else {
                    await insertFeed(widget.feed);
                  }

                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('保存'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
