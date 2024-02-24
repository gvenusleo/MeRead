import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get/get.dart';
import 'package:meread/common/global.dart';

class ScreenRefreshRateController extends GetxController {
  RxList modes = <DisplayMode>[].obs;
  late Rx<DisplayMode> activeMode;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  // 初始化数据
  Future<void> initData() async {
    modes.value = await FlutterDisplayMode.supported;
    activeMode = Rx<DisplayMode>(await FlutterDisplayMode.active);
  }

  // 切换刷新率
  Future<void> changeRefreshRate(DisplayMode mode) async {
    activeMode.value = mode;
    await FlutterDisplayMode.setPreferredMode(mode);
    logger.i('[Setting] 切换刷新率: ${mode.refreshRate}Hz');
  }
}
