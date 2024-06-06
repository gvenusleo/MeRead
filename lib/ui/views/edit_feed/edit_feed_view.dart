import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/ui/viewmodels/edit_feed/edit_feed_controller.dart';

class EditFeedView extends StatelessWidget {
  const EditFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    Feed feed = Get.arguments;
    final c = Get.put(EditFeedCntroller());
    c.initFeed(feed);
    final ColorScheme colorScheme = Get.theme.colorScheme;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text('editFeed'.tr),
          ),
          SliverList.list(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'feedAddress'.tr,
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: TextEditingController(text: feed.url),
                  enabled: false,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'feedName'.tr,
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: c.titleController,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'feedCategory'.tr,
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: c.categoryController,
                ),
              ),
              const SizedBox(height: 18),
              Obx(
                () => SwitchListTile(
                  value: c.fullText.value,
                  onChanged: (value) => c.updateFullText(value),
                  title: Text('fullText'.tr),
                  subtitle: Text('fullTextInfo'.tr),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                child: Text(
                  'openType'.tr,
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              for (int i = 0; i < 3; i++)
                RadioListTile(
                  value: i,
                  groupValue: c.feed?.openType ?? 0,
                  title: Text([
                    'openInApp'.tr,
                    'openInAppTab'.tr,
                    'openInBrowser'.tr
                  ][i]),
                  onChanged: (value) {
                    if (value != null) c.updateOpenType(value);
                  },
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: FilledButton.tonal(
                  onPressed: c.saveFeed,
                  child: Text('saveFeed'.tr),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 48),
                child: FilledButton.tonal(
                  onPressed: c.deleteFeed,
                  child: Text('deleteFeed'.tr),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
