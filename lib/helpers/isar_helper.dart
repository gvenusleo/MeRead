import 'dart:io';

import 'package:isar/isar.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:path_provider/path_provider.dart';

class IsarHelper {
  static late Isar _isar;

  static Future<void> init() async {
    final Directory dir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();
    _isar = await Isar.open(
      [FeedSchema, PostSchema],
      directory: dir.path,
    );
    LogHelper.i('[Isar]: Open isar database: ${dir.path}');
  }

  static void putFeed(Feed feed) {
    _isar.writeTxnSync(() {
      _isar.feeds.putSync(feed);
    });
  }

  static void deleteFeed(Feed feed) {
    _isar.writeTxnSync(() {
      _isar.feeds.deleteSync(feed.id!);
    });
  }

  static List<Feed> getFeeds() {
    return _isar.feeds.where().findAllSync();
  }

  static Feed? getFeedByUrl(String url) {
    return _isar.feeds.where().filter().urlEqualTo(url).findFirstSync();
  }

  static DateTime? getFeedLatestPubDate(Feed feed) {
    final List<Post> posts = _isar.posts
        .where()
        .filter()
        .feed((f) => f.idEqualTo(feed.id))
        .sortByPubDateDesc()
        .findAllSync();
    if (posts.isNotEmpty) {
      return posts.first.pubDate;
    }
    return null;
  }

  static void putPost(Post post) {
    _isar.writeTxnSync(() {
      _isar.posts.putSync(post);
    });
  }

  static void putPosts(List<Post> posts) {
    _isar.writeTxnSync(() {
      _isar.posts.putAllSync(posts);
    });
  }

  static deletePostsByFeed(Feed feed) {
    final List<Post> posts = getPostsByFeeds([feed]);
    _isar.writeTxnSync(() {
      _isar.posts.deleteAllSync(posts.map((e) => e.id!).toList());
    });
  }

  static List<Post> getPosts() {
    return _isar.posts.where().findAllSync();
  }

  static List<Post> getPostsByFeeds(List<Feed> feeds) {
    final List<Post> result = [];
    for (final Feed feed in feeds) {
      final List<Post> posts = _isar.posts
          .where()
          .filter()
          .feed((f) => f.idEqualTo(feed.id))
          .findAllSync();
      result.addAll(posts);
    }
    return result;
  }

  static List<Post> getPostsByText(String text) {
    return _isar.posts
        .where()
        .filter()
        .titleContains(text)
        .or()
        .contentContains(text)
        .findAllSync();
  }
}
