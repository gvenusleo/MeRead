import 'package:flutter/material.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class PagePaddingSettingPage extends StatelessWidget {
  PagePaddingSettingPage({Key? key}) : super(key: key);

  final Map<int, String> pagePaddingMap = {
    0: '最小',
    9: '较小',
    18: '适中',
    27: '较大',
    36: '最大',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面边距'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: pagePaddingMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: pagePaddingMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().pagePadding,
              title: Text(pagePaddingMap.values.toList()[index]),
              onChanged: (int? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().setPagePaddingState(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
