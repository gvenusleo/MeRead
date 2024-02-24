import 'package:get/get.dart';
import 'package:meread/common/helpers/prefs_helper.dart';

class BlockController extends GetxController {
  // 屏蔽词列表
  final blockWords = PrefsHelper.blockList.obs;

  // 添加屏蔽词
  Future<void> addBlockWord(String word) async {
    blockWords.add(word);
    await PrefsHelper.updateBlockList(blockWords);
  }

  // 删除屏蔽词
  Future<void> removeBlockWord(String word) async {
    blockWords.remove(word);
    await PrefsHelper.updateBlockList(blockWords);
  }
}
