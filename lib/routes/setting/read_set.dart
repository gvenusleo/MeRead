import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/key.dart';
import 'custom_css.dart';

class ReadSetPage extends StatefulWidget {
  const ReadSetPage({Key? key}) : super(key: key);

  @override
  State<ReadSetPage> createState() => ReadSetPageState();
}

class ReadSetPageState extends State<ReadSetPage> {
  int fontSize = 18;
  double lineheight = 1.5;
  int pagePadding = 18;
  String textAlign = 'justify';
  bool endAddLink = false;

  Future<void> initData() async {
    final int size = await getFontSize();
    final double height = await getLineheight();
    final int padding = await getPagePadding();
    final String align = await getTextAlign();
    final bool link = await getEndAddLink();
    setState(() {
      fontSize = size;
      lineheight = height;
      pagePadding = padding;
      textAlign = align;
      endAddLink = link;
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
          '阅读页面',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
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
              contentPadding: const EdgeInsets.all(0),
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
              contentPadding: const EdgeInsets.all(0),
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
              contentPadding: const EdgeInsets.all(0),
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
              contentPadding: const EdgeInsets.all(0),
              title: const Text('文章末尾显示原文链接'),
              trailing: Switch(
                value: endAddLink,
                onChanged: (bool value) async {
                  setState(() {
                    endAddLink = value;
                  });
                  await setEndAddLink(value);
                },
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
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
          ],
        ),
      ),
    );
  }
}
