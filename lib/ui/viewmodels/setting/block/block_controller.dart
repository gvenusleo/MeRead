import 'package:get/get.dart';
import 'package:meread/helpers/prefs_helper.dart';

class BlockController extends GetxController {
  final blockWords = PrefsHelper.blockList.obs;

  void addBlockWord(String word) {
    blockWords.add(word);
    PrefsHelper.blockList = blockWords;
  }

  void removeBlockWord(String word) {
    blockWords.remove(word);
    PrefsHelper.blockList = blockWords;
  }
}
