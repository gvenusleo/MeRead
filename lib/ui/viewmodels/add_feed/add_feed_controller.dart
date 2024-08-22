import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/feed_helper.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/models/feed.dart';

class AddFeedController extends GetxController {
  final addressController = TextEditingController();
  final RxBool isResolved = false.obs;
  Feed? feed;

  Future<void> pasteAddress() async {
    String? address = (await Clipboard.getData('text/plain'))?.text;
    if (address != null) {
      addressController.text = address;
      addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: address.length),
      );
    }
  }

  Future<void> resolveAddress() async {
    final url = addressController.text;
    feed = await FeedHelper.parse(url);
    isResolved.value = true;
  }

  Future<bool> isExists() async {
    final url = addressController.text;
    final Feed? result = IsarHelper.getFeedByUrl(url);
    if (result != null) {
      feed = result;
    }
    return result != null;
  }
}
