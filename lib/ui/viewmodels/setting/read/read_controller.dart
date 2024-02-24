import 'package:get/get.dart';
import 'package:meread/common/helpers/prefs_helper.dart';

class ReadController extends GetxController {
  // 字体大小
  RxInt fontSize = PrefsHelper.readFontSize.obs;
  // 行高
  RxDouble lineHeight = PrefsHelper.readLineHeight.obs;
  // 页面左右边距
  RxInt pagePadding = PrefsHelper.readPagePadding.obs;
  // 文字对齐方式
  RxString textAlign = PrefsHelper.readTextAlign.obs;

  // 更新字体大小
  Future<void> updateFontSize(int value) async {
    fontSize.value = value;
    await PrefsHelper.updateReadFontSize(value);
  }

  // 更新行高
  Future<void> updateLineHeight(double value) async {
    lineHeight.value = value;
    await PrefsHelper.updateReadLineHeight(value);
  }

  // 更新页面左右边距
  Future<void> updatePagePadding(int value) async {
    pagePadding.value = value;
    await PrefsHelper.updateReadPagePadding(value);
  }

  // 更新文字对齐方式
  Future<void> updateTextAlign(String value) async {
    textAlign.value = value;
    await PrefsHelper.updateReadTextAlign(value);
  }
}
