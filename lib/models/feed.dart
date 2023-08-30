import 'package:isar/isar.dart';
import 'package:meread/global/global.dart';
import 'package:meread/models/post.dart';

part 'feed.g.dart';

/// 定义 Feed 类
@collection
class Feed {
  Id? id = Isar.autoIncrement;
  String name; // 订阅源名称
  String url; // 订阅源地址
  String description; // 订阅源描述
  String category; // 订阅源分类
  bool fullText; // 是否全文
  int openType; // 打开方式：0-阅读器 1-内置标签页 2-系统浏览器

  Feed({
    this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.category,
    required this.fullText,
    required this.openType,
  });

  /// 根据 url 判断 Feed 是否已存在
  static Future<bool> isExist(String url) async {
    final List<Feed> feeds =
        isar.feeds.where().filter().urlEqualTo(url).findAllSync();
    return feeds.isNotEmpty;
  }

  /// 查询所有 Feed 并按分类分组
  static Future<Map<String, List<Feed>>> groupByCategory() async {
    final List<Feed> feeds = isar.feeds.where().findAllSync();
    Map<String, List<Feed>> feedsGroupByCategory = {};
    for (var feed in feeds) {
      if (feedsGroupByCategory[feed.category] == null) {
        feedsGroupByCategory[feed.category] = [];
      }
      feedsGroupByCategory[feed.category]!.add(feed);
    }
    return feedsGroupByCategory;
  }

  /// 查询所有 Feed 未读 Post 数量，返回一个 Map
  static Future<Map<int, int>> unreadPostCount() async {
    final List<Feed> feeds = isar.feeds.where().findAllSync();
    final Map<int, int> unreadPostCount = {};
    for (var feed in feeds) {
      final List<Post> posts = isar.posts
          .where()
          .filter()
          .feedIdEqualTo(feed.id!)
          .readEqualTo(false)
          .findAllSync();
      unreadPostCount[feed.id!] = posts.length;
    }
    return unreadPostCount;
  }

  /// 获取 Feed 下最新的 Post 的 pubDate
  Future<String?> getLatesPubDate() async {
    final List<Post> posts = isar.posts
        .where()
        .filter()
        .feedIdEqualTo(id!)
        .sortByPubDateDesc()
        .findAllSync();
    if (posts.isEmpty) {
      return null;
    }
    return posts.first.pubDate;
  }

  /// 将 Feed 插入数据库
  Future<void> insertOrUpdateToDb() async {
    await isar.writeTxn(() async {
      await isar.feeds.put(this);
    });
  }

  /// 更新 Feed 下所有 Post 中的 feedName 和 openType
  Future<void> updatePostsFeedNameAndOpenType() async {
    final List<Post> posts =
        isar.posts.where().filter().feedIdEqualTo(id!).findAllSync();
    for (var post in posts) {
      post.feedName = name;
      post.openType = openType;
      await post.updateToDb();
    }
  }

  /// 删除 Feed
  Future<void> deleteFromDb() async {
    /* 删除订阅源 */
    await isar.writeTxn(() async {
      await isar.feeds.delete(id!);
    });
    /* 删除该订阅源的所有文章 */
    final List<Post> posts =
        isar.posts.where().filter().feedIdEqualTo(id!).findAllSync();
    final List<int> postsId = posts.map((e) => e.id!).toList();
    await isar.writeTxn(() async {
      await isar.posts.deleteAll(postsId);
    });
  }
}
