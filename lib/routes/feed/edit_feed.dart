import 'package:flutter/material.dart';

import '../../utils/db.dart';
import '../../models/models.dart';

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
        title: const Text(
          '编辑订阅',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _urlController,
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
              decoration: const InputDecoration(
                labelText: '订阅源地址',
                enabled: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
              decoration: const InputDecoration(
                labelText: '订阅源名称',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _categoryController,
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
              decoration: const InputDecoration(
                labelText: '订阅源分类',
              ),
            ),
          ),
          const Divider(),
          // 获取全文
          ListTile(
            title: const Text('是否获取全文'),
            trailing: Switch(
              value: widget.feed.fullText == 0 ? false : true,
              onChanged: (bool value) {
                setState(() {
                  widget.feed.fullText = value ? 1 : 0;
                });
              },
            ),
          ),
          // 文章打开方式
          ListTile(
            title: const Text('文章打开方式'),
            trailing: DropdownButton(
              value: widget.feed.openType,
              elevation: 1,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text(
                    '阅读器',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(
                    '内置标签页',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text(
                    '系统浏览器',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineSmall!.color,
                    ),
                  ),
                ),
              ],
              onChanged: (int? value) {
                setState(() {
                  widget.feed.openType = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          // 取消与保存
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
              const SizedBox(width: 24),
              OutlinedButton(
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
