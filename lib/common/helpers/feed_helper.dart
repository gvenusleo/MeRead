import 'package:dart_rss/dart_rss.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:meread/common/global.dart';
import 'package:meread/common/helpers/post_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';

class FeedHelper {
  /// 解析订阅源
  /// 参数：订阅源地址
  /// 返回：[Feed] 对象
  /// 注意：同时考虑 RSS 和 Atom 格式
  static Future<Feed?> parse(
    String url, [
    String? categoryName,
    String? feedTitle,
  ]) async {
    categoryName ??= 'defaultCategory'.tr;
    try {
      final Dio dio = appDio.dio;
      final response = await dio.get(url);
      final postXmlString = response.data;
      try {
        /* 使用 RSS 格式解析 */
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
        /* 使用 Atom 格式解析 */
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
      logger.e('[feed] 解析订阅源失败: $e');
      return null;
    }
  }

  /// 保存订阅源到 Isar
  static Future<void> saveToIsar(Feed feed) async {
    await isar.writeTxn(() async {
      await isar.feeds.put(feed);
    });
  }

  /// 根据 url 判断 Isar 数据库中是否已存在
  static Future<Feed?> isExists(String url) async {
    final Feed? result =
        await isar.feeds.where().filter().urlEqualTo(url).findFirst();
    return result;
  }

  /// 从 Isar 获取所有订阅源
  static Future<List<Feed>> getFeeds() async {
    final List<Feed> feeds = await isar.feeds.where().findAll();
    return feeds;
  }

  /// 获取 Feed 所属的 Post 最新 pubDate
  static Future<DateTime?> getLatesPubDate(Feed feed) async {
    final List<Post> posts = await isar.posts
        .where()
        .filter()
        .feed((f) => f.idEqualTo(feed.id))
        .sortByPubDateDesc()
        .findAll();
    if (posts.isNotEmpty) {
      return posts.first.pubDate;
    } else {
      return null;
    }
  }

  /// 删除订阅源
  static Future<void> deleteFeed(Feed feed) async {
    await PostHelper.deletePostsByFeed(feed);
    await isar.writeTxn(() async {
      await isar.feeds.delete(feed.id!);
    });
  }
}
