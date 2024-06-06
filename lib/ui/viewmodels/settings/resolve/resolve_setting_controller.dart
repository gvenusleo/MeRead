import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/prefs_helper.dart';

class ResolveSettingController extends GetxController {
  RxBool refreshOnStartup = PrefsHelper.refreshOnStartup.obs;
  RxList<String> blockWords = PrefsHelper.blockList.obs;
  RxBool useProxy = PrefsHelper.useProxy.obs;
  RxString proxyAddress = PrefsHelper.proxyAddress.obs;
  RxString proxyPort = PrefsHelper.proxyPort.obs;

  void changeRefreshOnStartup(bool value) {
    if (value == refreshOnStartup.value) return;
    refreshOnStartup.value = value;
    PrefsHelper.refreshOnStartup = value;
  }

  void changeBlockWords(List<String> value) {
    if (value == blockWords) return;
    blockWords.assignAll(value);
    PrefsHelper.blockList = value;
  }

  void changeUseProxy(bool value) {
    if (proxyAddress.value.isEmpty || proxyPort.value.isEmpty) {
      Fluttertoast.showToast(msg: 'useProxyFailedInfo'.tr);
      return;
    }
    if (value == useProxy.value) return;
    useProxy.value = value;
    PrefsHelper.useProxy = value;
  }

  void changeProxyAddress(String value) {
    if (value == proxyAddress.value || value.isEmpty) return;
    proxyAddress.value = value;
    PrefsHelper.proxyAddress = value;
  }

  void changeProxyPort(String value) {
    if (value == proxyPort.value || value.isEmpty) return;
    proxyPort.value = value;
    PrefsHelper.proxyPort = value;
  }
}
