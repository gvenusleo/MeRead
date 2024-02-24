import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/setting/screen_refresh_rate/screen_refresh_rate_controller.dart';
import 'package:meread/ui/widgets/item_card.dart';

class ScreenRefreshRateSettingView extends StatelessWidget {
  const ScreenRefreshRateSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ScreenRefreshRateController());
    return Scaffold(
      appBar: AppBar(
        title: Text('screenRefreshRate'.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: ItemCard(
            title: 'screenRefreshRate'.tr,
            item: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (DisplayMode mode in c.modes) ...[
                    InkWell(
                      onTap: () => c.changeRefreshRate(mode),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: c.activeMode.value == mode
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${mode.height}x${mode.width}  ${mode.refreshRate.toStringAsFixed(0)}Hz',
                            style: TextStyle(
                              fontSize: 16,
                              color: c.activeMode.value == mode
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    mode == c.modes.last
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 8),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
