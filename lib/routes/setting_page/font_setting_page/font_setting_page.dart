import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:meread/utils/font_manager.dart';
import 'package:provider/provider.dart';

class FontSettingPage extends StatefulWidget {
  const FontSettingPage({Key? key}) : super(key: key);

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
        title: Text(AppLocalizations.of(context)!.globalFont),
        actions: [
          // 添加字体
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
                        horizontal: 24, vertical: 12),
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('删除确认'),
                      content: Text(
                        '确认删除字体：${_fontNameList[index - 1]}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (context.read<ThemeProvider>().themeFont ==
                                _fontNameList[index - 1]) {
                              context
                                  .read<ThemeProvider>()
                                  .changeThemeFont('思源黑体');
                            }
                            // 删除字体
                            await deleteFont(_fontNameList[index - 1]);
                            // 重新初始化字体名称列表
                            await initData();
                            if (!mounted) return;
                            Navigator.pop(context);
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
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
