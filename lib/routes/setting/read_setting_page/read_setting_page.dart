import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/setting.dart';
import 'custom_css_page/custom_css_page.dart';

class ReadSettingPage extends StatefulWidget {
  const ReadSettingPage({super.key});

  @override
  State<ReadSettingPage> createState() => _ReadSettingPageState();
}

class _ReadSettingPageState extends State<ReadSettingPage> {
  int fontSize = 18;
  double lineheight = 1.5;
  int pagePadding = 18;
  String textAlign = '两端对齐';

  final Map<String, String> alignMap = {
    'left': '左对齐',
    'right': '右对齐',
    'center': '居中对齐',
    'justify': '两端对齐',
  };

  Future<void> initData() async {
    final int size = await getFontSize();
    final double height = await getLineheight();
    final int padding = await getPagePadding();
    final String align = await getTextAlign();

    setState(() {
      fontSize = size;
      lineheight = height;
      pagePadding = padding;
      textAlign = alignMap[align] ?? '两端对齐';
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
        title: const Text('阅读页面'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.text_increase_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('字体大小'),
              subtitle: Text(fontSize.toString()),
              onTap: showSetFontSizeDialog,
            ),
            ListTile(
              leading: const Icon(Icons.vertical_distribute_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('行间距'),
              subtitle: Text(lineheight.toStringAsFixed(1)),
              onTap: showSetLineHeightDialog,
            ),
            ListTile(
              leading: const Icon(Icons.space_bar_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('页面边距'),
              subtitle: Text(pagePadding.toString()),
              onTap: showSetPagePaddingDialog,
            ),
            ListTile(
              leading: const Icon(Icons.format_align_left_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('文字对齐'),
              subtitle: Text(textAlign),
              onTap: showSetTextAlignDialog,
            ),
            ListTile(
              leading: const Icon(Icons.code_outlined),
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              title: const Text('自定义 CSS'),
              subtitle: const Text('阅读页面 CSS 样式'),
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

  // 设置字体大小
  Future<void> showSetFontSizeDialog() async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setFontSizeState) {
          return AlertDialog(
            title: const Text('字体大小'),
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('14'),
                      Text('24'),
                    ],
                  ),
                ),
                Slider(
                  value: fontSize.toDouble(),
                  min: 14,
                  max: 24,
                  divisions: 10,
                  label: fontSize.toString(),
                  onChanged: (double value) async {
                    setFontSizeState(() {
                      fontSize = value.toInt();
                    });
                    setState(() {
                      fontSize = value.toInt();
                    });
                    await setFontSize(fontSize);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 设置行间距
  Future<void> showSetLineHeightDialog() async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLineheightState) {
          return AlertDialog(
            title: const Text('行间距'),
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('1.0'),
                      Text('3.0'),
                    ],
                  ),
                ),
                Slider(
                  value: lineheight,
                  min: 1.0,
                  max: 3.0,
                  divisions: 20,
                  label: lineheight.toStringAsFixed(1),
                  onChanged: (double value) async {
                    setLineheightState(() {
                      lineheight = value;
                    });
                    setState(() {
                      lineheight = value;
                    });
                    await setLineheight(lineheight);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 设置页面边距
  Future<void> showSetPagePaddingDialog() async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setPagePaddingState) {
          return AlertDialog(
            title: const Text('页面边距'),
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('0'),
                      Text('36'),
                    ],
                  ),
                ),
                Slider(
                  value: pagePadding.toDouble(),
                  min: 0,
                  max: 36,
                  divisions: 18,
                  label: pagePadding.toString(),
                  onChanged: (double value) async {
                    setPagePaddingState(() {
                      pagePadding = value.toInt();
                    });
                    setState(() {
                      pagePadding = value.toInt();
                    });
                    await setPagePadding(pagePadding);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 设置文字对齐
  Future<void> showSetTextAlignDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('文字对齐'),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: alignMap.entries.map((e) {
            return RadioListTile(
              value: e.value,
              groupValue: textAlign,
              title: Text(e.value),
              onChanged: (String? value) async {
                if (value != null) {
                  setState(() {
                    textAlign = value;
                  });
                  await setTextAlign(e.key);
                }
                if (!mounted) return;
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
