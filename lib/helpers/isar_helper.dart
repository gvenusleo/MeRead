import 'dart:io';

import 'package:isar/isar.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/models/category.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:path_provider/path_provider.dart';

class IsarHelper {
  static late Isar _isar;

  /// Init Isar
  static Future<void> init() async {
    final Directory dir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();
    _isar = await Isar.open(
      [FeedSchema, PostSchema, CategorySchema],
      directory: dir.path,
    );
    LogHelper.i('[Isar]: Open isar database: ${dir.path}.');
  }

  /// Get all Feeds from the Isar database
  static Future<List<Feed>> getFeeds() async {
    final List<Feed> feeds = await _isar.feeds.where().findAll();
    return feeds;
  }

  /// Save a Feed to the Isar database
  static void saveFeed(Feed feed) {
    _isar.writeTxnSync(() {
      _isar.feeds.putSync(feed);
    });
  }

  /// Determine if the Feed exists in the Isar database based on the URL
  static Future<Feed?> isExistsFeed(String url) async {
    final Feed? result =
        await _isar.feeds.where().filter().urlEqualTo(url).findFirst();
    return result;
  }

  /// Get the latest pubDate of the Post to which the feed belongs
  static Future<DateTime?> getLatesPubDate(Feed feed) async {
    final List<Post> posts = await _isar.posts
        .where()
        .filter()
        .feed((f) => f.idEqualTo(feed.id))
        .sortByPubDateDesc()
        .findAll();
    if (posts.isNotEmpty) {
      return posts.first.pubDate;
    }
    return null;
  }

  /// Delete a Feed from the Isar database
  static Future<void> deleteFeed(Feed feed) async {
    final List<Post> posts = await _isar.posts
        .where()
        .filter()
        .feed((f) => f.idEqualTo(feed.id))
        .findAll();

    _isar.writeTxnSync(() {
      _isar.posts.deleteAllSync(posts.map((e) => e.id!).toList());
      _isar.feeds.deleteSync(feed.id!);
    });
  }

  /// Get all Posts from the Isar database
  static Future<List<Post>> getPosts() async {
    final List<Post> posts = await _isar.posts.where().findAll();
    return posts;
  }

  /// Save a Post to the Isar database
  static void savePost(Post post) {
    _isar.writeTxnSync(() {
      _isar.posts.putSync(post);
    });
  }

  /// Get the associated Post from the Isar database through List<Feed>
  static Future<List<Post>> getPostsByFeeds(List<Feed> feeds) async {
    final List<Post> result = [];
    for (final Feed feed in feeds) {
      final List<Post> posts = await _isar.posts
          .where()
          .filter()
          .feed((f) => f.idEqualTo(feed.id))
          .findAll();
      result.addAll(posts);
    }
    return result;
  }

  /// Search from title and content
  static Future<List<Post>> search(String value) async {
    if (value.isEmpty) {
      return [];
    }
    final List<Post> result = await _isar.posts
        .where()
        .filter()
        .titleContains(value)
        .or()
        .contentContains(value)
        .findAll();
    return result;
  }

  /// Modify Post reading status
  static void updatePostRead(Post post) {
    _isar.writeTxnSync(() {
      post.read = !post.read;
      _isar.posts.putSync(post);
    });
  }

  /// Mark all Posts as Read
  static void markAllRead(List<Post> posts) {
    for (var post in posts) {
      post.read = true;
    }
    _isar.writeTxnSync(() {
      _isar.posts.putAllSync(posts);
    });
  }

  /// Get all Category from the Isar database
  static Future<List<Category>> getCategorys() async {
    final List<Category> categories = await _isar.categorys.where().findAll();
    return categories;
  }

  /// Search Category by name from the Isar database
  static Future<Category?> getCategoryByName(String name) async {
    final Category? result =
        await _isar.categorys.where().filter().nameEqualTo(name).findFirst();
    return result;
  }
}
