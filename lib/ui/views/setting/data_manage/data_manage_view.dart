import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/opml_helper.dart';

class DataManageView extends StatelessWidget {
  const DataManageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text('dataManage'.tr),
          ),
          SliverList.list(
            children: [
              ListTile(
                leading: const Icon(Icons.download_rounded),
                title: Text('importOpml'.tr),
                subtitle: Text(
                  'importOpmlInfo'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
                onTap: OpmlHelper.importOpml,
              ),
              ListTile(
                leading: const Icon(Icons.publish_rounded),
                title: Text('exportOpml'.tr),
                subtitle: Text(
                  'exportOpmlInfo'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.outline),
                ),
                onTap: OpmlHelper.exportOpml,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
