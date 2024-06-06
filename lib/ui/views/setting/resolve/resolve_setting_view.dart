import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/settings/resolve/resolve_setting_controller.dart';

class ResolveSettingView extends StatelessWidget {
  const ResolveSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ResolveSettingController());
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text('resolveSetting'.tr),
          ),
          SliverList.list(
            children: [
              Obx(() => SwitchListTile(
                    value: c.refreshOnStartup.value,
                    onChanged: c.changeRefreshOnStartup,
                    title: Text('refreshOnStartup'.tr),
                    subtitle: Text(
                      'refreshOnStartupInfo'.tr,
                      style: TextStyle(color: Get.theme.colorScheme.outline),
                    ),
                    secondary: const Icon(Icons.refresh_rounded),
                  )),
              ListTile(
                leading: const Icon(Icons.block_rounded),
                title: Text('blockWords'.tr),
                subtitle: Text(
                  'blockWordsInfo'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
                onTap: () {
                  List<String> words = c.blockWords;
                  Get.dialog(
                    StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          scrollable: true,
                          icon: const Icon(Icons.block_rounded),
                          title: Text('blockWords'.tr),
                          content: Column(
                            children: [
                              for (int i = 0; i < words.length; i++)
                                ListTile(
                                  title: Text(words[i]),
                                  trailing: IconButton(
                                    icon: const Icon(
                                        Icons.do_not_disturb_on_rounded),
                                    onPressed: () => setState(() {
                                      words.removeAt(i);
                                    }),
                                  ),
                                ),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  child: Text('add'.tr),
                                  onPressed: () {
                                    final controller = TextEditingController();
                                    Get.dialog(
                                      AlertDialog(
                                        icon: const Icon(Icons.add_rounded),
                                        title: Text('addBlockWord'.tr),
                                        content: TextField(
                                          controller: controller,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            border:
                                                const UnderlineInputBorder(),
                                            hintText: 'addBlockWord'.tr,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('cancel'.tr),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('confirm'.tr),
                                            onPressed: () {
                                              if (controller.text.isNotEmpty) {
                                                setState(() {
                                                  words.add(controller.text);
                                                });
                                              }
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const Spacer(),
                                TextButton(
                                  child: Text('cancel'.tr),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: Text('confirm'.tr),
                                  onPressed: () {
                                    c.changeBlockWords(words);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
              Obx(
                () => SwitchListTile(
                  value: c.useProxy.value,
                  onChanged: c.changeUseProxy,
                  title: Text('useProxy'.tr),
                  subtitle: Text(
                    'useProxyInfo'.tr,
                    style: TextStyle(color: Get.theme.colorScheme.outline),
                  ),
                  secondary: const Icon(Icons.public_rounded),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.link_rounded),
                title: Text('proxyAddress'.tr),
                subtitle: Obx(() => Text(
                      c.proxyAddress.value.isEmpty
                          ? 'notSet'.tr
                          : c.proxyAddress.value,
                      style: TextStyle(color: Get.theme.colorScheme.outline),
                    )),
                onTap: () {
                  final controller =
                      TextEditingController(text: c.proxyAddress.value);
                  Get.dialog(
                    AlertDialog(
                      icon: const Icon(Icons.link_rounded),
                      title: Text('proxyAddress'.tr),
                      content: TextField(
                        controller: controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          hintText: 'proxyAddress'.tr,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('cancel'.tr),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: Text('confirm'.tr),
                          onPressed: () {
                            c.changeProxyAddress(controller.text);
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.tag_rounded),
                title: Text('proxyPort'.tr),
                subtitle: Obx(() => Text(
                      c.proxyPort.value.toString().isEmpty
                          ? 'notSet'.tr
                          : c.proxyPort.value.toString(),
                      style: TextStyle(color: Get.theme.colorScheme.outline),
                    )),
                onTap: () {
                  final controller =
                      TextEditingController(text: c.proxyPort.value.toString());
                  Get.dialog(
                    AlertDialog(
                      icon: const Icon(Icons.tag_rounded),
                      title: Text('proxyPort'.tr),
                      content: TextField(
                        controller: controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          hintText: 'proxyPort'.tr,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('cancel'.tr),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: Text('confirm'.tr),
                          onPressed: () {
                            c.changeProxyPort(controller.text);
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
