import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/add_feed/add_feed_controller.dart';

class AddFeedView extends StatelessWidget {
  const AddFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddFeedController());
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            title: Text('addFeed'.tr),
          ),
          SliverList.list(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text('feedAddress'.tr),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: c.addressController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
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
                    return GestureDetector(
                      onTap: () async {
                        final bool isExist = await c.isExists();
                        if (isExist) {
                          Fluttertoast.showToast(
                            msg: 'feedAlreadyExists'.tr,
                          );
                          return;
                        }
                        Get.toNamed('/editFeed', arguments: c.feed)!
                            .then((_) => Get.back());
                      },
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.feed!.title,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            Text(c.feed!.description),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
