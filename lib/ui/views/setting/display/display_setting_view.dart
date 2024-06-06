import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/settings/display/display_setting_controller.dart';

class DisplaySettingView extends StatelessWidget {
  const DisplaySettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DisplaySettingController());
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text('displaySetting'.tr),
          ),
          SliverList.list(
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode_rounded),
                title: Text('darkMode'.tr),
                subtitle: Obx(() => Text(
                      [
                        'followSystem'.tr,
                        'close'.tr,
                        'open'.tr,
                      ][c.themeMode.value],
                      style: TextStyle(color: Get.theme.colorScheme.outline),
                    )),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const VerticalDivider(
                      indent: 12,
                      endIndent: 12,
                      width: 24,
                    ),
                    Obx(() => Switch(
                          value: c.themeMode.value == 2,
                          onChanged: (value) =>
                              c.changeThemeMode(value ? 2 : 1),
                        )),
                  ],
                ),
                onTap: () {
                  int mode = c.themeMode.value;
                  Get.dialog(AlertDialog(
                    icon: const Icon(Icons.dark_mode_rounded),
                    title: Text('darkMode'.tr),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (int i = 0; i < 3; i++)
                              RadioListTile(
                                value: i,
                                groupValue: mode,
                                title: Text(
                                  [
                                    'followSystem'.tr,
                                    'close'.tr,
                                    'open'.tr,
                                  ][i],
                                ),
                                onChanged: (value) {
                                  if (value != null && value != mode) {
                                    setState(() {
                                      mode = value;
                                    });
                                  }
                                },
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('cancel'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          c.changeThemeMode(mode);
                          Get.back();
                        },
                        child: Text('confirm'.tr),
                      ),
                    ],
                  ));
                },
              ),
              Obx(() => SwitchListTile(
                    value: c.enableDynamicColor.value,
                    secondary: const Icon(Icons.color_lens_rounded),
                    title: Text('dynamicColor'.tr),
                    subtitle: Text(
                      'dynamicColorInfo'.tr,
                      style: TextStyle(color: Get.theme.colorScheme.outline),
                    ),
                    onChanged: (value) => c.changeEnableDynamicColor(value),
                  )),
              ListTile(
                leading: const Icon(Icons.font_download_rounded),
                title: Text('globalFont'.tr),
                subtitle: Obx(() => Text(
                      c.globalFont.value == 'system'
                          ? 'defaultFont'.tr
                          : c.globalFont.value.split('.').first,
                      style: TextStyle(color: Get.theme.colorScheme.outline),
                    )),
                onTap: () async {
                  String selestedFont = c.globalFont.value;
                  await c.refreshFontList();
                  Get.dialog(
                    StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                          icon: const Icon(Icons.font_download_rounded),
                          title: Text('globalFont'.tr),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (String font in c.fontList)
                                RadioListTile(
                                  value: font,
                                  groupValue: selestedFont,
                                  title: Text(
                                    font == 'system'
                                        ? 'defaultFont'.tr
                                        : font.split('.').first,
                                    style: TextStyle(fontFamily: font),
                                  ),
                                  onChanged: (value) {
                                    if (value != null &&
                                        value != selestedFont) {
                                      setState(() {
                                        selestedFont = value;
                                      });
                                    }
                                  },
                                  secondary: font == 'system'
                                      ? null
                                      : IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_rounded),
                                          onPressed: () async {
                                            await c.deleteFont(font);
                                            setState(() {});
                                          },
                                        ),
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80),
                                  ),
                                ),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    c.importFont().then((_) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text('importFont'.tr),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('cancel'.tr),
                                ),
                                TextButton(
                                  onPressed: () {
                                    c.changeGlobalFont(selestedFont);
                                    Get.back();
                                  },
                                  child: Text('confirm'.tr),
                                ),
                              ],
                            ),
                          ]);
                    }),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.animation_rounded),
                title: Text('animationEffect'.tr),
                subtitle: Obx(() => Text(
                      {
                            'cupertino': 'smoothScrolling'.tr,
                            'fade': 'fadeInAndOut'.tr,
                          }[c.transition.value] ??
                          'smoothScrolling'.tr,
                      style: TextStyle(color: Get.theme.colorScheme.outline),
                    )),
                onTap: () {
                  String selectedTransition = c.transition.value;
                  final Map<String, String> transitions = {
                    'cupertino': 'smoothScrolling'.tr,
                    'fade': 'fadeInAndOut'.tr,
                  };
                  Get.dialog(
                    StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          icon: const Icon(Icons.animation_rounded),
                          title: Text('animationEffect'.tr),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (String key in transitions.keys)
                                RadioListTile(
                                  value: key,
                                  groupValue: selectedTransition,
                                  title: Text(transitions[key] ?? ''),
                                  onChanged: (value) {
                                    if (value != null &&
                                        value != selectedTransition) {
                                      setState(() {
                                        selectedTransition = value;
                                      });
                                    }
                                  },
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Text('* ${'animationEffectInfo'.tr}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('cancel'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                c.changeTransition(selectedTransition);
                                Get.back();
                              },
                              child: Text('confirm'.tr),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
              ListTile(
                  leading: const Icon(Icons.text_fields_rounded),
                  title: Text('textScale'.tr),
                  subtitle: Obx(() => Text(
                        'textScaleFactor'.tr +
                            c.textScaleFactor.value.toStringAsFixed(1),
                        style: TextStyle(color: Get.theme.colorScheme.outline),
                      )),
                  onTap: () {
                    double factor = c.textScaleFactor.value;
                    Get.dialog(AlertDialog(
                      icon: const Icon(Icons.text_fields_rounded),
                      title: Text('textScale'.tr),
                      content: StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            height: 64,
                            child: Slider(
                              value: factor,
                              min: 0.8,
                              max: 2.0,
                              divisions: 12,
                              label: factor.toStringAsFixed(1),
                              onChanged: (value) {
                                setState(() {
                                  factor = value;
                                });
                              },
                            ),
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('cancel'.tr),
                        ),
                        TextButton(
                          onPressed: () {
                            c.changeTextScaleFactor(factor);
                            Get.back();
                          },
                          child: Text('confirm'.tr),
                        ),
                      ],
                    ));
                  }),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text('language'.tr),
                subtitle: Obx(() => Text(
                      [
                        'systemLanguage'.tr,
                        'zh_CN'.tr,
                        'en_US'.tr,
                      ][c.languageList.indexOf(c.language.value)],
                      style: TextStyle(color: Get.theme.colorScheme.outline),
                    )),
                onTap: () {
                  String selectedLanguage = c.language.value;
                  Get.dialog(AlertDialog(
                    icon: const Icon(Icons.language_rounded),
                    title: Text('language'.tr),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (String language in c.languageList)
                              RadioListTile(
                                value: language,
                                groupValue: selectedLanguage,
                                title: Text(
                                  [
                                    'systemLanguage'.tr,
                                    'zh_CN'.tr,
                                    'en_US'.tr,
                                  ][c.languageList.indexOf(language)],
                                ),
                                onChanged: (value) {
                                  if (value != null &&
                                      value != selectedLanguage) {
                                    setState(() {
                                      selectedLanguage = value;
                                    });
                                  }
                                },
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('cancel'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          c.changeLanguage(selectedLanguage);
                          Get.back();
                        },
                        child: Text('confirm'.tr),
                      ),
                    ],
                  ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
