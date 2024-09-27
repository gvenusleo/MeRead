import 'dart:io';

import 'package:isar/isar.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/folder.dart';
import 'package:meread/models/post.dart';
import 'package:path_provider/path_provider.dart';

class IsarHelper {
  static late Isar _isar;

  static Isar get isar => _isar;

  /// 初始化 Isar 数据库 ( App 打开时)
  static Future<void> init() async {
    final Directory dir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();
    _isar = await Isar.open(
      [FolderSchema, FeedSchema, PostSchema],
      directory: dir.path,
    );
    LogHelper.i('[Isar]: Open isar database: ${dir.path}');
  }

  /// 保存 Folder
  static void putFolder(Folder folder) {
    _isar.writeTxnSync(() {
      _isar.folders.putSync(folder);
    });
  }

  /// 删除 Folder (同时删除关联的 Feed 和 Post)
  static void deleteFolder(Folder folder) {
    final List<Feed> feeds = folder.feeds.toList();
    for (Feed feed in feeds) {
      deleteFeed(feed);
    }
    _isar.writeTxnSync(() {
      _isar.folders.deleteSync(folder.id);
    });
  }

  /// 获取所有 Folder
  static List<Folder> getFolders() {
    return _isar.folders.where().findAllSync();
  }

  /// 保存 Feed
  static void putFeed(Feed feed) {
    _isar.writeTxnSync(() {
      _isar.feeds.putSync(feed);
    });
  }

  /// 删除 Feed (同时删除关联到 Feed 的所有 Post)
  static void deleteFeed(Feed feed) {
    deletePostsByFeed(feed);
    _isar.writeTxnSync(() {
      _isar.feeds.deleteSync(feed.id!);
    });
  }

  /// 获取所有 Feed
  static List<Feed> getFeeds() {
    return _isar.feeds.where().findAllSync();
  }

  /// 通过 url 查找 Feed
  static Feed? getFeedByUrl(String url) {
    return _isar.feeds.where().filter().urlEqualTo(url).findFirstSync();
  }

  /// 获取 Feed 的上一次拉取到的最新 Post 发布时间
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

  /// 保存 Post
  static void putPost(Post post) {
    _isar.writeTxnSync(() {
      _isar.posts.putSync(post);
    });
  }

  /// 保存多个 Post
  static void putPosts(List<Post> posts) {
    _isar.writeTxnSync(() {
      _isar.posts.putAllSync(posts);
    });
  }

  /// 删除关联到 Feed 的所有 Post
  static deletePostsByFeed(Feed feed) {
    _isar.writeTxnSync(() {
      _isar.posts.deleteAllSync(feed.post.map((e) => e.id!).toList());
    });
  }

  /// 获取所有 Post
  static List<Post> getPosts() {
    return _isar.posts.where().findAllSync();
  }

  /// 搜索 Post (通过文本在 titlr 和 contenr 中搜索)
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
