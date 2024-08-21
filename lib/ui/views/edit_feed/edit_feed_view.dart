import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/ui/viewmodels/edit_feed/edit_feed_controller.dart';
import 'package:meread/ui/widgets/input_item_card.dart';
import 'package:meread/ui/widgets/item_card.dart';

class EditFeedView extends StatelessWidget {
  const EditFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    Feed feed = Get.arguments;
    final c = Get.put(EditFeedCntroller());
    c.initFeed(feed);
    final List<String> openTypes = [
      'openInApp'.tr,
      'openInAppBrowser'.tr,
      'openInSystemBrowser'.tr
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('editFeed'.tr),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          children: [
            InputItemCard(
              title: 'feedAddress'.tr,
              controller: TextEditingController(text: feed.url),
              inputEnabled: false,
            ),
            const SizedBox(height: 12),
            InputItemCard(
              title: 'feedTitle'.tr,
              controller: c.titleController,
            ),
            const SizedBox(height: 12),
            InputItemCard(
              title: 'feedCategory'.tr,
              controller: c.categoryController,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Obx(
                () => SwitchListTile(
                  value: c.fullText.value,
                  onChanged: (value) => c.updateFullText(value),
                  title: Text('fullText'.tr),
                  tileColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withAlpha(80),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            ItemCard(
              title: 'openType'.tr,
              item: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 3; i++) ...[
                      InkWell(
                        onTap: () => c.updateOpenType(i),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: c.openType.value == i
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              openTypes[i],
                              style: TextStyle(
                                fontSize: 16,
                                color: c.openType.value == i
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      i == 2
                          ? const SizedBox.shrink()
                          : const SizedBox(height: 8),
                    ]
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: FilledButton.tonal(
                onPressed: c.saveFeed,
                child: Text('saveFeed'.tr),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: FilledButton.tonal(
                onPressed: c.deleteFeed,
                child: Text('deleteFeed'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
