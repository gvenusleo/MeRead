import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/opml_helper.dart';
import 'package:meread/helpers/update_helper.dart';
import 'package:meread/ui/widgets/list_item_card.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('moreSettings'.tr),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
          children: [
            ListItemCard(
              trailing: const Icon(Icons.language_outlined),
              title: 'languageSettings'.tr,
              onTap: () {
                Get.toNamed('/setting/language');
              },
            ),
            const SizedBox(height: 12),
            ListItemCard(
              trailing: const Icon(Icons.color_lens_outlined),
              title: 'appearanceSettings'.tr,
              onTap: () {
                Get.toNamed('/setting/theme');
              },
              bottomRadius: false,
            ),
            const Divider(
              indent: 18,
              endIndent: 18,
            ),
            ListItemCard(
              trailing: const Icon(Icons.display_settings_outlined),
              title: 'screenRefreshRate'.tr,
              onTap: () {
                Get.toNamed('/setting/screenRefreshRate');
              },
              topRadius: false,
            ),
            const SizedBox(height: 12),
            ListItemCard(
              trailing: const Icon(Icons.article_outlined),
              title: 'readSettings'.tr,
              onTap: () {
                Get.toNamed('/setting/read');
              },
            ),
            const SizedBox(height: 12),
            ListItemCard(
              trailing: const Icon(Icons.refresh_outlined),
              title: 'refreshSettings'.tr,
              onTap: () {
                Get.toNamed('/setting/refresh');
              },
              bottomRadius: false,
            ),
            const Divider(
              indent: 18,
              endIndent: 18,
            ),
            ListItemCard(
              trailing: const Icon(Icons.block_outlined),
              title: 'blockSettings'.tr,
              onTap: () {
                Get.toNamed('/setting/block');
              },
              topRadius: false,
              bottomRadius: false,
            ),
            const Divider(
              indent: 18,
              endIndent: 18,
            ),
            ListItemCard(
              trailing: const Icon(Icons.smart_button_outlined),
              title: 'proxySettings'.tr,
              onTap: () {
                Get.toNamed('/setting/proxy');
              },
              topRadius: false,
            ),
            const SizedBox(height: 12),
            ListItemCard(
              trailing: const Icon(Icons.file_download_outlined),
              title: 'importOPML'.tr,
              onTap: OpmlHelper.importOPML,
              bottomRadius: false,
            ),
            const Divider(
              indent: 18,
              endIndent: 18,
            ),
            ListItemCard(
              trailing: const Icon(Icons.file_upload_outlined),
              title: 'exportOPML'.tr,
              onTap: OpmlHelper.exportOPML,
              topRadius: false,
            ),
            const SizedBox(height: 12),
            ListItemCard(
              trailing: const Icon(Icons.update_outlined),
              title: 'checkUpdate'.tr,
              onTap: UpdateHelper.checkUpdate,
              bottomRadius: false,
            ),
            const Divider(
              indent: 18,
              endIndent: 18,
            ),
            ListItemCard(
              trailing: const Icon(Icons.android_outlined),
              title: 'aboutApp'.tr,
              onTap: () {
                Get.toNamed('/setting/about');
              },
              topRadius: false,
            ),
          ],
        ),
      ),
    );
  }
}
