import 'package:flutter/material.dart';
import 'package:meread/global/global.dart';

class BlockSettingPage extends StatefulWidget {
  const BlockSettingPage({Key? key}) : super(key: key);

  @override
  State<BlockSettingPage> createState() => _BlockSettingPageState();
}

class _BlockSettingPageState extends State<BlockSettingPage> {
  final List<String> _blockList = prefs.getStringList('blockList') ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('屏蔽规则'),
        actions: [
          // 添加字体
          IconButton(
            onPressed: () async {
              final TextEditingController controller = TextEditingController();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('添加屏蔽规则'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: '输入需要屏蔽的字词',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            setState(() {
                              _blockList.add(controller.text);
                            });
                            prefs.setStringList('blockList', _blockList);
                            setState(() {});
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _blockList.length + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == _blockList.length) {
              return const Divider();
            }
            if (index == _blockList.length + 1) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('* 点击右上角添加需要屏蔽的字词\n* 标题含有屏蔽字词的文章将被隐藏'),
              );
            }
            return ListTile(
              title: Text(_blockList[index]),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _blockList.removeAt(index);
                  });
                  prefs.setStringList('blockList', _blockList);
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
            );
          },
        ),
      ),
    );
  }
}
