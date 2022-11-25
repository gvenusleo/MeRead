import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:meread/routes/setting/about.dart';
import 'package:meread/routes/setting/api_set.dart';
import 'package:meread/routes/setting/parse_set.dart';
import 'package:meread/routes/setting/read_set.dart';
import 'package:meread/states/state.dart';

class SetPage extends StatefulWidget {
  const SetPage({super.key});

  @override
  State<SetPage> createState() => _SetPageState();
}

class _SetPageState extends State<SetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '设置',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        children: [
          // TODO：语言设置
          ListTile(
            title: const Text(
              '颜色主题',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        RadioListTile(
                          value: 0,
                          groupValue:
                              Provider.of<ThemeModel>(context).themeIndex,
                          title: const Text('浅色'),
                          onChanged: (int? value) async {
                            context.read<ThemeModel>().setTheme(value!);
                            if (!mounted) return;
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          value: 1,
                          groupValue:
                              Provider.of<ThemeModel>(context).themeIndex,
                          title: const Text('深色'),
                          onChanged: (value) {
                            context.read<ThemeModel>().setTheme(value!);
                            if (!mounted) return;
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          value: 2,
                          groupValue:
                              Provider.of<ThemeModel>(context).themeIndex,
                          title: const Text('跟随系统'),
                          onChanged: (value) {
                            context.read<ThemeModel>().setTheme(value!);
                            if (!mounted) return;
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text(
              '阅读页面',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ReadSetPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              '解析设置',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ParseSetPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              '接口配置',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ApiSetPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              '关于应用',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return const AboutPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
