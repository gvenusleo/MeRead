import 'package:flutter/material.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class TextScaleFactorSettingPage extends StatelessWidget {
  TextScaleFactorSettingPage({Key? key}) : super(key: key);

  final Map<double, String> textScaleFactorMap = {
    0.8: '最小',
    0.9: '较小',
    1.0: '适中',
    1.1: '较大',
    1.2: '最大',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('全局缩放'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: textScaleFactorMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: textScaleFactorMap.keys.toList()[index],
              groupValue: context.watch<ThemeProvider>().textScaleFactor,
              title: Text(textScaleFactorMap.values.toList()[index]),
              onChanged: (value) {
                if (value != null) {
                  context.read<ThemeProvider>().changeTextScaleFactor(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
