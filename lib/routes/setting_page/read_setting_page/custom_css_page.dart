import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:provider/provider.dart';

class CustomCssPage extends StatefulWidget {
  const CustomCssPage({Key? key}) : super(key: key);

  @override
  CustomCssPageState createState() => CustomCssPageState();
}

class CustomCssPageState extends State<CustomCssPage> {
  final TextEditingController _customCssController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customCssController.text = context.read<ReadPageProvider>().customCss;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义 CSS'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          children: [
            TextFormField(
              controller: _customCssController,
              expands: false,
              maxLines: 12,
              decoration: const InputDecoration(
                hintText: '输入 CSS 代码',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // 从剪贴板获取，光标移到末尾
                    Clipboard.getData('text/plain').then((value) {
                      if (value != null) {
                        _customCssController.text = value.text!;
                        _customCssController.selection =
                            TextSelection.fromPosition(
                                TextPosition(offset: value.text!.length));
                      }
                    });
                  },
                  child: const Text('粘贴'),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () async {
                    await context
                        .read<ReadPageProvider>()
                        .setCustomCssState(_customCssController.text);
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('保存'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
