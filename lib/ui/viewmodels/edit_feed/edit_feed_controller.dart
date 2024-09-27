import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/models/feed.dart';

class EditFeedCntroller extends GetxController {
  RxBool fullText = false.obs;
  RxInt openType = 0.obs;
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  late Feed feed;

  // 初始化 Feed
  void initFeed(Feed feed) {
    fullText.value = feed.fullText;
    openType.value = feed.openType;
    titleController.text = feed.title;
    categoryController.text = feed.folder.value?.name ?? '';
    feed = feed;
  }

  // 更新 fullText
  void updateFullText(bool value) {
    fullText.value = value;
  }

  // 更新 openType
  void updateOpenType(int value) {
    openType.value = value;
  }

  // 保存 Feed
  Future<void> saveFeed() async {
    feed.title = titleController.text;
    feed.fullText = fullText.value;
    feed.openType = openType.value;
    IsarHelper.putFeed(feed);
    Get.back();
  }

  // 删除 Feed
  Future<void> deleteFeed() async {
    if (feed.id == null) {
      Get.back();
    } else {
      IsarHelper.deleteFeed(feed);
      Get.back();
    }
  }
}
