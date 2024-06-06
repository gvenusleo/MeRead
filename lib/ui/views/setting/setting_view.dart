import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text('moreSetting'.tr),
          ),
          SliverList.list(
            children: [
              ListTile(
                leading: const Icon(Icons.color_lens_rounded),
                title: Text('displaySetting'.tr),
                subtitle: Text(
                  'displaySettingInfo'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
                onTap: () => Get.toNamed('/setting/display'),
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text('readSetting'.tr),
                subtitle: Text(
                  'readSettingInfo'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
                onTap: () => Get.toNamed('/setting/read'),
              ),
              ListTile(
                leading: const Icon(Icons.travel_explore_rounded),
                title: Text('resolveSetting'.tr),
                subtitle: Text(
                  'resolveSettingInfo'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
                onTap: () => Get.toNamed('/setting/resolve'),
              ),
              ListTile(
                leading: const Icon(Icons.data_usage_rounded),
                title: Text('dataManage'.tr),
                subtitle: Text(
                  'dataManageInfo'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
                onTap: () => Get.toNamed('/setting/data_manage'),
              ),
              ListTile(
                leading: const Icon(Icons.android_outlined),
                title: Text('aboutApp'.tr),
                subtitle: Text(
                  'aboutAppInfo'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
                onTap: () {
                  Get.toNamed('/setting/about');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
