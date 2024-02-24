import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/setting/read/read_controller.dart';
import 'package:meread/ui/widgets/item_card.dart';
import 'package:meread/ui/widgets/slide_item_card.dart';

class ReadSettingView extends StatelessWidget {
  const ReadSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ReadController());
    return Scaffold(
      appBar: AppBar(
        title: Text('readSettings'.tr),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          children: [
            SlideItemCard(
              title: 'fontSize'.tr,
              value: c.fontSize.value.toDouble(),
              minValue: 12,
              maxValue: 22,
              divisions: 10,
              stringFixed: 0,
              afterChange: (value) {
                c.updateFontSize(value.toInt());
              },
            ),
            const SizedBox(height: 12),
            SlideItemCard(
              title: 'lineHeight'.tr,
              value: c.lineHeight.value,
              minValue: 1.0,
              maxValue: 2.0,
              divisions: 10,
              stringFixed: 1,
              afterChange: (value) {
                c.updateLineHeight(value);
              },
            ),
            const SizedBox(height: 12),
            SlideItemCard(
              title: 'pagePadding'.tr,
              value: c.pagePadding.value.toDouble(),
              minValue: 0,
              maxValue: 40,
              divisions: 10,
              stringFixed: 0,
              afterChange: (value) {
                c.updatePagePadding(value.toInt());
              },
            ),
            const SizedBox(height: 12),
            ItemCard(
              title: 'textAlign'.tr,
              item: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (String mode in [
                      'left',
                      'right',
                      'center',
                      'justify'
                    ]) ...[
                      InkWell(
                        onTap: () => c.updateTextAlign(mode),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: c.textAlign.value == mode
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${mode}Align'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: c.textAlign.value == mode
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      mode == 'justify'
                          ? const SizedBox.shrink()
                          : const SizedBox(height: 8),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
