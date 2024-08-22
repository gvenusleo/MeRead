import 'package:get/get.dart';
import 'package:meread/helpers/prefs_helper.dart';

class ReadController extends GetxController {
  final RxInt fontSize = PrefsHelper.readFontSize.obs;
  final RxDouble lineHeight = PrefsHelper.readLineHeight.obs;
  final RxInt pagePadding = PrefsHelper.readPagePadding.obs;
  final RxString textAlign = PrefsHelper.readTextAlign.obs;

  void updateFontSize(int value) {
    if (fontSize.value == value) return;
    fontSize.value = value;
    PrefsHelper.readFontSize = value;
  }

  void updateLineHeight(double value) {
    if (lineHeight.value == value) return;
    lineHeight.value = value;
    PrefsHelper.readLineHeight = value;
  }

  void updatePagePadding(int value) {
    if (pagePadding.value == value) return;
    pagePadding.value = value;
    PrefsHelper.readPagePadding = value;
  }

  void updateTextAlign(String value) {
    if (textAlign.value == value) return;
    textAlign.value = value;
    PrefsHelper.readTextAlign = value;
  }
}
