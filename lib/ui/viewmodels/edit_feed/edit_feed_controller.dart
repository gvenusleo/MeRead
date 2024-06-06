import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/models/category.dart';
import 'package:meread/models/feed.dart';

class EditFeedCntroller extends GetxController {
  RxBool fullText = false.obs;
  RxInt openType = 0.obs;
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  Feed? feed;

  void initFeed(Feed value) {
    fullText.value = value.fullText;
    openType.value = value.openType;
    titleController.text = value.title;
    categoryController.text = value.category.value?.name ?? '';
    feed = value;
  }

  void updateFullText(bool value) {
    fullText.value = value;
  }

  void updateOpenType(int value) {
    openType.value = value;
  }

  Future<void> saveFeed() async {
    final newFeed = Feed(
      id: feed?.id,
      title: titleController.text,
      url: feed?.url ?? '',
      description: feed?.description ?? '',
      fullText: fullText.value,
      openType: openType.value,
    );
    final Category category =
        await IsarHelper.getCategoryByName(categoryController.text) ??
            Category(
              name: categoryController.text,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
    newFeed.category.value = category;
    IsarHelper.saveFeed(newFeed);
    Get.back();
  }

  void deleteFeed() {
    if (feed == null || feed?.id == null) {
      Get.back();
    } else {
      IsarHelper.deleteFeed(feed!);
      Get.back();
    }
  }
}
