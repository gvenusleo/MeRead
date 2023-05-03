import 'package:flutter/material.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class FontSizeSettingPage extends StatelessWidget {
  FontSizeSettingPage({Key? key}) : super(key: key);

  final Map<int, String> fontSizeMap = {
    14: '最小',
    16: '较小',
    18: '适中',
    20: '较大',
    22: '最大',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字体大小'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: fontSizeMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: fontSizeMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().fontSize,
              title: Text(fontSizeMap.values.toList()[index]),
              onChanged: (int? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().changeFontSize(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
