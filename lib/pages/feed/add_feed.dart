import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:meread/utils/db.dart';
import 'package:meread/utils/parse.dart';
import 'package:meread/pages/feed/edit_feed.dart';
import 'package:meread/models/models.dart';

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
    _feedWidget = const SizedBox(
      height: 0,
      width: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '添加订阅',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: ListView(
            children: [
              TextField(
                autofocus: true,
                controller: _urlController,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headlineSmall!.color,
                ),
                decoration: const InputDecoration(
                  hintText: '输入订阅源地址',
                  labelText: '订阅源地址',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        // 从剪贴板获取订阅源地址，光标移到末尾
                        Clipboard.getData('text/plain').then((value) {
                          if (value != null) {
                            _urlController.text = value.text!;
                            _urlController.selection =
                                TextSelection.fromPosition(
                                    TextPosition(offset: value.text!.length));
                          }
                        });
                      },
                      child: const Text('粘贴')),
                  const SizedBox(width: 24),
                  OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode()); // 收起键盘
                      if (await feedExist(_urlController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '订阅源已存在',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        return;
                      } else {
                        Feed? feed = await parseFeed(_urlController.text);
                        if (feed != null) {
                          setState(() {
                            _feedWidget = Card(
                              elevation: 0,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: ListTile(
                                  title: Text(feed.name),
                                  subtitle: Text(
                                    feed.description,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  minVerticalPadding: 12,
                                  onTap: () {
                                    // 打开编辑页面
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            EditFeedPage(feed: feed),
                                      ),
                                    );
                                  }),
                            );
                          });
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '无法解析订阅源',
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      '解析',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _feedWidget,
            ],
          ),
        ));
  }
}
