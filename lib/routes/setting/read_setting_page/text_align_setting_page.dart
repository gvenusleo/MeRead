import 'package:flutter/material.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class TextAlignSettingPage extends StatelessWidget {
  TextAlignSettingPage({Key? key}) : super(key: key);

  final Map<String, String> textAlignMap = {
    'left': '左对齐',
    'right': '右对齐',
    'center': '居中对齐',
    'justify': '两端对齐',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('文字对齐'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: textAlignMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: textAlignMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().textAlign,
              title: Text(textAlignMap.values.toList()[index]),
              onChanged: (String? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().setTextAlignState(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
