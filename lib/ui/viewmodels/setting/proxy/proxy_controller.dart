import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/common/helpers/prefs_helper.dart';

class ProxyController extends GetxController {
  // 是否使用代理
  final useProxy = PrefsHelper.useProxy.obs;
  // 代理地址
  final proxyAddress = PrefsHelper.proxyAddress.obs;
  // 代理端口
  final proxyPort = PrefsHelper.proxyPort.obs;

  // 更新是否使用代理
  Future<void> updateUseProxy(bool value) async {
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
    await PrefsHelper.updateUseProxy(value);
  }

  // 更新代理地址
  Future<void> updateProxyAddress(String value) async {
    proxyAddress.value = value;
    await PrefsHelper.updateProxyAddress(value);
  }

  // 更新代理端口
  Future<void> updateProxyPort(String value) async {
    proxyPort.value = value;
    await PrefsHelper.updateProxyPort(value);
  }
}
