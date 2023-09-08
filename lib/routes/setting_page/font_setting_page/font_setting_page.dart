import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:meread/utils/font_util.dart';
import 'package:provider/provider.dart';

class FontSettingPage extends StatefulWidget {
  const FontSettingPage({super.key, this.needLeading = true});
  final bool needLeading;

  @override
  State<FontSettingPage> createState() => _FontSettingPageState();
}

class _FontSettingPageState extends State<FontSettingPage> {
  List<String> _fontNameList = []; // 字体名称列表

  // 初始化字体名称列表
  Future<void> initData() async {
    await readAllFont().then(
      (value) => setState(() => _fontNameList = value),
    );
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
        leading: widget.needLeading ? null : const SizedBox.shrink(),
        leadingWidth: widget.needLeading ? null : 0,
        title: Text(AppLocalizations.of(context)!.globalFont),
        actions: [
          /* 添加字体 */
          IconButton(
            onPressed: () async {
              // 从本地文件导入字体
              await loadLocalFont();
              // 重新初始化字体名称列表
              await initData();
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _fontNameList.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return RadioListTile(
                value: '默认字体',
                groupValue: context.watch<ThemeProvider>().themeFont,
                title: Text(
                  AppLocalizations.of(context)!.defaultFont,
                  style: const TextStyle(fontFamily: '默认字体'),
                ),
                onChanged: (value) {
                  if (value != null) {
                    context.read<ThemeProvider>().changeThemeFont(value);
                  }
                },
              );
            }
            if (index == _fontNameList.length + 1) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.fontInfo,
                    ),
                  ),
                ],
              );
            }
            return RadioListTile(
              value: _fontNameList[index - 1],
              groupValue: context.watch<ThemeProvider>().themeFont,
              title: Text(
                _fontNameList[index - 1].split('.').first,
                style: TextStyle(fontFamily: _fontNameList[index - 1]),
              ),
              onChanged: (value) {
                if (value != null) {
                  context.read<ThemeProvider>().changeThemeFont(value);
                }
              },
              secondary: IconButton(
                onPressed: () async {
                  /* 删除字体 */
                  if (context.read<ThemeProvider>().themeFont ==
                      _fontNameList[index - 1]) {
                    context.read<ThemeProvider>().changeThemeFont('默认字体');
                  }
                  await deleteFont(_fontNameList[index - 1]);
                  await initData();
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
