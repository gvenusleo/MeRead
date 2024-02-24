import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/setting/block/block_controller.dart';
import 'package:meread/ui/widgets/item_card.dart';

class BlockSettingView extends StatelessWidget {
  const BlockSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BlockController());
    return Scaffold(
      appBar: AppBar(
        title: Text('blockSettings'.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: ItemCard(
            title: 'blockSettings'.tr,
            item: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (String word in c.blockWords) ...[
                        Container(
                          width: double.infinity,
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                word,
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                onPressed: () {
                                  c.removeBlockWord(word);
                                },
                                icon: Icon(
                                  Icons.delete_forever_outlined,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final TextEditingController controller =
                          TextEditingController();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: const Icon(Icons.block_outlined),
                            title: Text('addBlockWord'.tr),
                            content: TextField(
                              controller: controller,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'blockWord'.tr,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('cancel'.tr),
                              ),
                              TextButton(
                                onPressed: () {
                                  c.addBlockWord(controller.text);
                                  Navigator.pop(context);
                                },
                                child: Text('ok'.tr),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add_outlined),
                    label: Text('addBlockWord'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
