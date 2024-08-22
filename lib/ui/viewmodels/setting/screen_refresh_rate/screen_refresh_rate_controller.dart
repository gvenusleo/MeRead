import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/log_helper.dart';

class ScreenRefreshRateController extends GetxController {
  RxList modes = <DisplayMode>[].obs;
  Rx<DisplayMode> activeMode = DisplayMode.auto.obs;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  Future<void> initData() async {
    modes.value = await FlutterDisplayMode.supported;
    activeMode = Rx<DisplayMode>(await FlutterDisplayMode.active);
  }

  Future<void> updateRefreshRate(DisplayMode mode) async {
    activeMode.value = mode;
    await FlutterDisplayMode.setPreferredMode(mode);
    LogHelper.i('[Setting] Change refresh rate to: ${mode.refreshRate}Hz');
  }
}
