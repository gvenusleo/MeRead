import 'package:flutter/material.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class LineHeightSettingPage extends StatelessWidget {
  LineHeightSettingPage({Key? key}) : super(key: key);

  final Map<double, String> lineHeightMap = {
    1.0: '最小',
    1.2: '较小',
    1.5: '适中',
    1.8: '较大',
    2.0: '最大',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('行高'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: lineHeightMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: lineHeightMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().lineHeight,
              title: Text(lineHeightMap.values.toList()[index]),
              onChanged: (double? value) async {
                if (value != null) {
                  context.read<ReadPageProvider>().setLineHeightState(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
