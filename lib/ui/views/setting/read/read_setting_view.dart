import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/settings/read/read_controller.dart';

class ReadSettingView extends StatelessWidget {
  const ReadSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ReadController());
    final Map<String, String> alignMap = {
      'left': 'leftAlign'.tr,
      'right': 'rightAlign'.tr,
      'center': 'centerAlign'.tr,
      'justify': 'justifyAlign'.tr,
    };
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text('readSetting'.tr),
          ),
          SliverList.list(
            children: [
              ListTile(
                leading: const Icon(Icons.text_fields_rounded),
                title: Text('fontSize'.tr),
                subtitle: Obx(() => Text('${c.fontSize.value}')),
                onTap: () {
                  int size = c.fontSize.value;
                  Get.dialog(AlertDialog(
                    icon: const Icon(Icons.text_fields_rounded),
                    title: Text('fontSize'.tr),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return SizedBox(
                          height: 64,
                          child: Slider(
                            value: size.toDouble(),
                            min: 12,
                            max: 24,
                            divisions: 12,
                            label: size.toInt().toString(),
                            onChanged: (value) {
                              setState(() {
                                size = value.toInt();
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
                          c.changeFontSize(size);
                          Get.back();
                        },
                        child: Text('confirm'.tr),
                      ),
                    ],
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.line_weight_rounded),
                title: Text('lineHeight'.tr),
                subtitle:
                    Obx(() => Text(c.lineHeight.value.toStringAsFixed(1))),
                onTap: () {
                  double height = c.lineHeight.value;
                  Get.dialog(AlertDialog(
                    icon: const Icon(Icons.line_weight_rounded),
                    title: Text('lineHeight'.tr),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return SizedBox(
                          height: 64,
                          child: Slider(
                            value: height,
                            min: 1.0,
                            max: 2.0,
                            divisions: 10,
                            label: height.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                height = value;
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
                          c.changeLineHeight(height);
                          Get.back();
                        },
                        child: Text('confirm'.tr),
                      ),
                    ],
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.padding_rounded),
                title: Text('pagePadding'.tr),
                subtitle: Obx(() => Text('${c.pagePadding.value}')),
                onTap: () {
                  int padding = c.pagePadding.value;
                  Get.dialog(AlertDialog(
                    icon: const Icon(Icons.padding_rounded),
                    title: Text('pagePadding'.tr),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return SizedBox(
                          height: 64,
                          child: Slider(
                            value: padding.toDouble(),
                            min: 0,
                            max: 40,
                            divisions: 10,
                            label: padding.toString(),
                            onChanged: (value) {
                              setState(() {
                                padding = value.toInt();
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
                          c.changePagePadding(padding);
                          Get.back();
                        },
                        child: Text('confirm'.tr),
                      ),
                    ],
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.format_align_left_rounded),
                title: Text('textAlign'.tr),
                subtitle: Obx(
                    () => Text(alignMap[c.textAlign.value] ?? 'leftAlign'.tr)),
                onTap: () {
                  String align = c.textAlign.value;
                  Get.dialog(AlertDialog(
                    icon: const Icon(Icons.format_align_left_rounded),
                    title: Text('textAlign'.tr),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (String i in alignMap.keys)
                              RadioListTile(
                                value: i,
                                groupValue: align,
                                title: Text(
                                  alignMap[i] ?? '',
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      align = value;
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
                          c.changeTextAlign(align);
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
