import 'package:get/get.dart';
import 'package:meread/common/helpers/prefs_helper.dart';

class RefreshCOntroller extends GetxController {
  // 启动时刷新
  RxBool refreshOnStartup = PrefsHelper.refreshOnStartup.obs;

  Future<void> updateRefreshOnStartup(bool value) async {
    refreshOnStartup.value = value;
    await PrefsHelper.updateRefreshOnStartup(value);
  }
}
