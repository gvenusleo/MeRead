import 'package:dart_rss/dart_rss.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/dio_helper.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/models/feed.dart';

class FeedHelper {
  static Future<Feed?> parse(
    String url, [
    String? categoryName,
    String? feedTitle,
  ]) async {
    categoryName ??= 'defaultCategory'.tr;
    try {
      final response = await DioHelper.get(url);
      final postXmlString = response.data;
      try {
        final RssFeed rssFeed = RssFeed.parse(postXmlString);
        feedTitle = rssFeed.title;
        return Feed(
          title: feedTitle ?? '',
          url: url,
          description: rssFeed.description ?? '',
          category: categoryName,
          fullText: false,
          openType: 0,
        );
      } catch (e) {
        final AtomFeed atomFeed = AtomFeed.parse(postXmlString);
        return Feed(
          title: atomFeed.title ?? '',
          url: url,
          description: atomFeed.subtitle ?? '',
          category: categoryName,
          fullText: false,
          openType: 0,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'resolveError'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      LogHelper.e('[feed] Parse error: $e');
      return null;
    }
  }
}
