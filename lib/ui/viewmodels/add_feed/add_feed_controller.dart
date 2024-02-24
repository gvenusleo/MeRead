import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meread/common/helpers/feed_helper.dart';
import 'package:meread/models/feed.dart';

class AddFeedController extends GetxController {
  // 订阅源地址编辑器
  final addressController = TextEditingController();
  // 是否解析完成
  RxBool isResolved = false.obs;
  // 解析得到的订阅源
  Feed? feed;

  // 粘贴订阅源地址
  Future<void> pasteAddress() async {
    String? address = (await Clipboard.getData('text/plain'))?.text;
    if (address != null) {
      addressController.text = address;
      addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: address.length),
      );
    }
  }

  // 解析订阅源地址
  Future<void> resolveAddress() async {
    final url = addressController.text;
    feed = await FeedHelper.parse(url);
    isResolved.value = true;
  }

  // 根据订阅源地址判断 Isar 数据库中是否已存在
  // 存在则替换当前订阅源
  Future<bool> isExists() async {
    final url = addressController.text;
    final result = await FeedHelper.isExists(url);
    if (result != null) {
      feed = result;
    }
    return result != null;
  }
}
