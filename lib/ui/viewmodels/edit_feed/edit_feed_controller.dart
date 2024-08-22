import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/models/feed.dart';

class EditFeedCntroller extends GetxController {
  RxBool fullText = false.obs;
  RxInt openType = 0.obs;
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  Feed? feed;

  // 初始化订阅源
  void initFeed(Feed value) {
    fullText.value = value.fullText;
    openType.value = value.openType;
    titleController.text = value.title;
    categoryController.text = value.category;
    feed = value;
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
    final newFeed = Feed(
      id: feed?.id,
      title: titleController.text,
      url: feed?.url ?? '',
      description: feed?.description ?? '',
      category: categoryController.text,
      fullText: fullText.value,
      openType: openType.value,
    );
    IsarHelper.putFeed(newFeed);
    Get.back();
  }

  // 删除 Feed
  Future<void> deleteFeed() async {
    if (feed == null || feed?.id == null) {
      Get.back();
    } else {
      IsarHelper.deleteFeed(feed!);
      Get.back();
    }
  }
}
