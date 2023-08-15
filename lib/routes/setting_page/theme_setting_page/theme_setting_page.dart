import 'package:flutter/material.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSettingPage extends StatefulWidget {
  const ThemeSettingPage({super.key});

  @override
  State<ThemeSettingPage> createState() => _ThemeSettingPageState();
}

class _ThemeSettingPageState extends State<ThemeSettingPage> {
  List<String> themeMode = ['浅色模式', '深色模式', '跟随系统'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主题颜色'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: themeMode.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: index,
              groupValue: context.watch<ThemeProvider>().themeIndex,
              title: Text(themeMode[index]),
              onChanged: (int? value) async {
                if (value != null) {
                  context.read<ThemeProvider>().changeThemeIndex(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
