import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/add_feed/add_feed_controller.dart';
import 'package:meread/ui/widgets/input_item_card.dart';
import 'package:meread/ui/widgets/item_card.dart';

class AddFeedView extends StatelessWidget {
  const AddFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddFeedController());
    return Scaffold(
      appBar: AppBar(
        title: Text('addFeed'.tr),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          children: [
            InputItemCard(
              title: 'feedAddress'.tr,
              controller: c.addressController,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: FilledButton.tonal(
                      onPressed: c.pasteAddress,
                      child: Text('pasteAddress'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: FilledButton.tonal(
                      onPressed: c.resolveAddress,
                      child: Text('resloveAddress'.tr),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Obx(() {
                if (c.isResolved.value && c.feed != null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: InkWell(
                      onTap: () async {
                        final bool isExist = await c.isExists();
                        if (isExist) {
                          Get.snackbar('info'.tr, 'feedExist'.tr);
                        }
                        Get.toNamed('/editFeed', arguments: c.feed)!
                            .then((_) => Get.back());
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ItemCard(
                          title: c.feed!.title,
                          item: Text(c.feed!.description),
                          margin: const EdgeInsets.all(0),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
