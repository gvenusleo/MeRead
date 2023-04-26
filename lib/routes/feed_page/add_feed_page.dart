import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/parse.dart';
import '../../models/feed.dart';
import 'edit_feed.dart';

class AddFeedPage extends StatefulWidget {
  const AddFeedPage({super.key});

  @override
  State<AddFeedPage> createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> {
  final TextEditingController _urlController = TextEditingController();

  Widget _feedWidget = const SizedBox(); // 展示解析得到的 Feed 详情

  @override
  void initState() {
    super.initState();
    _feedWidget = const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加订阅'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          children: [
            TextField(
              autofocus: true,
              controller: _urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '输入订阅源地址',
                labelText: '订阅源地址',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // 从剪贴板获取订阅源地址，光标移到末尾
                    Clipboard.getData('text/plain').then(
                      (value) {
                        if (value != null) {
                          _urlController.text = value.text!;
                          _urlController.selection = TextSelection.fromPosition(
                            TextPosition(offset: value.text!.length),
                          );
                        }
                      },
                    );
                  },
                  child: const Text('粘贴'),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode()); // 收起键盘
                    if (await Feed.isExist(_urlController.text)) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('订阅源已存在'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(label: '确定', onPressed: () {}),
                        ),
                      );
                    } else {
                      Feed? feed = await parseFeed(_urlController.text);
                      if (feed != null) {
                        setState(() {
                          _feedWidget = Card(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: ListTile(
                              title: Text(feed.name),
                              subtitle: Text(
                                feed.description,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              minVerticalPadding: 12,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              onTap: () {
                                // 打开编辑页面
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        EditFeedPage(feed: feed),
                                  ),
                                ).then(
                                  (value) => Navigator.pop(context),
                                );
                              },
                            ),
                          );
                        });
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('无法解析订阅源'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            action:
                                SnackBarAction(label: '确定', onPressed: () {}),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('解析'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _feedWidget,
            ),
          ],
        ),
      ),
    );
  }
}
