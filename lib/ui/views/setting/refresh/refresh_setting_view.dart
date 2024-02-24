import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/setting/refresh/refresh_controller.dart';

class RefreshSettingView extends StatelessWidget {
  const RefreshSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RefreshCOntroller());
    return Scaffold(
      appBar: AppBar(
        title: Text('refreshSettings'.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Obx(
              () => SwitchListTile(
                value: c.refreshOnStartup.value,
                title: Text('refreshOnStartup'.tr),
                subtitle: Text('refreshOnStartupInfo'.tr),
                onChanged: (value) {
                  c.updateRefreshOnStartup(value);
                },
                tileColor:
                    Theme.of(context).colorScheme.surfaceVariant.withAlpha(80),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
