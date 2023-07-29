import 'package:flutter/material.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class DynamicColorSettingPage extends StatelessWidget {
  const DynamicColorSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动态取色'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SwitchListTile(
              value: context.watch<ThemeProvider>().isDynamicColor,
              onChanged: (bool value) async {
                context.read<ThemeProvider>().changeDynamicColor(value);
              },
              title: const Text('壁纸动态取色'),
              subtitle: const Text('主题颜色根据桌面壁纸自动变化'),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text('* 壁纸动态取色需要系统 Android 版本不低于 12\n* 开启前请自行确认设备受支持'),
            ),
          ],
        ),
      ),
    );
  }
}
