import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/prefs_helper.dart';

class ProxyController extends GetxController {
  final RxBool useProxy = PrefsHelper.useProxy.obs;
  final RxString proxyAddress = PrefsHelper.proxyAddress.obs;
  final RxString proxyPort = PrefsHelper.proxyPort.obs;

  void updateUseProxy(bool value) {
    if (useProxy.value == value) return;
    if (proxyAddress.value.isEmpty || proxyPort.value.isEmpty) {
      Get.snackbar(
        'info'.tr,
        'addressAndPortCannotBeEmpty'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }
    useProxy.value = value;
    PrefsHelper.useProxy = value;
  }

  void updateProxyAddress(String value) {
    if (proxyAddress.value == value) return;
    proxyAddress.value = value;
    PrefsHelper.proxyAddress = value;
  }

  void updateProxyPort(String value) {
    if (proxyPort.value == value) return;
    proxyPort.value = value;
    PrefsHelper.proxyPort = value;
  }
}
