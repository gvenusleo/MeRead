import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/global/global.dart';

class BlockSettingPage extends StatefulWidget {
  const BlockSettingPage({Key? key}) : super(key: key);

  @override
  State<BlockSettingPage> createState() => _BlockSettingPageState();
}

class _BlockSettingPageState extends State<BlockSettingPage> {
  // 屏蔽词列表
  final List<String> _blockList = prefs.getStringList('blockList') ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.blockRules),
        actions: [
          // 添加屏蔽词
          IconButton(
            onPressed: () async {
              final TextEditingController controller = TextEditingController();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.addBlockRule),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.enterBlockedWord,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.cancel),
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
                        child: Text(AppLocalizations.of(context)!.ok),
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
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(AppLocalizations.of(context)!.blockInfo),
              );
            }
            return ListTile(
              title: Text(_blockList[index]),
              trailing: IconButton(
                onPressed: () {
                  /* 删除屏蔽词 */
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
