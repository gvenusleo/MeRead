import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/setting/refresh/refresh_controller.dart';
import 'package:meread/ui/widgets/switch_item_card.dart';

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
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
          child: Obx(() => SwitchItemCard(
                title: Text('refreshOnStartup'.tr),
                subtitle: Text('refreshOnStartupInfo'.tr),
                value: c.refreshOnStartup.value,
                onChanged: (value) => c.updateRefreshOnStartup(value),
              )),
        ),
      ),
    );
  }
}
