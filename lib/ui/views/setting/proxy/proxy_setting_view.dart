import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/setting/proxy/proxy_controller.dart';
import 'package:meread/ui/widgets/input_item_card.dart';
import 'package:meread/ui/widgets/switch_item_card.dart';

class ProxySettingView extends StatelessWidget {
  const ProxySettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProxyController());
    final addressController = TextEditingController(text: c.proxyAddress.value);
    final portController = TextEditingController(text: c.proxyPort.value);
    return Scaffold(
      appBar: AppBar(
        title: Text('proxySettings'.tr),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
          children: [
            Obx(
              () => SwitchItemCard(
                value: c.useProxy.value,
                onChanged: (value) => c.updateUseProxy(value),
                title: Text('useProxy'.tr),
                subtitle: Text('useProxyInfo'.tr),
              ),
            ),
            const SizedBox(height: 12),
            InputItemCard(
              title: 'proxyAddress'.tr,
              controller: addressController,
              hintText: 'http://',
              onChanged: (value) {
                c.updateProxyAddress(value);
              },
            ),
            const SizedBox(height: 12),
            InputItemCard(
              title: 'proxyPort'.tr,
              controller: portController,
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              hintText: '7890',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                c.updateProxyPort(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
