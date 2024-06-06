import 'package:get/get.dart';
import 'package:meread/helpers/prefs_helper.dart';

class ReadController extends GetxController {
  RxInt fontSize = PrefsHelper.readFontSize.obs;
  RxDouble lineHeight = PrefsHelper.readLineHeight.obs;
  RxInt pagePadding = PrefsHelper.readPagePadding.obs;
  RxString textAlign = PrefsHelper.readTextAlign.obs;

  void changeFontSize(int value) {
    if (value == fontSize.value) return;
    fontSize.value = value;
    PrefsHelper.readFontSize = value;
  }

  void changeLineHeight(double value) {
    if (value == lineHeight.value) return;
    lineHeight.value = value;
    PrefsHelper.readLineHeight = value;
  }

  void changePagePadding(int value) {
    if (value == pagePadding.value) return;
    pagePadding.value = value;
    PrefsHelper.readPagePadding = value;
  }

  void changeTextAlign(String value) {
    if (value == textAlign.value) return;
    textAlign.value = value;
    PrefsHelper.readTextAlign = value;
  }
}
