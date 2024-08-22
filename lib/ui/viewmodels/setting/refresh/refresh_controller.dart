import 'package:get/get.dart';
import 'package:meread/helpers/prefs_helper.dart';

class RefreshCOntroller extends GetxController {
  final RxBool refreshOnStartup = PrefsHelper.refreshOnStartup.obs;

  void updateRefreshOnStartup(bool value) {
    if (refreshOnStartup.value == value) return;
    refreshOnStartup.value = value;
    PrefsHelper.refreshOnStartup = value;
  }
}
