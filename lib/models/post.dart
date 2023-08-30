import 'package:isar/isar.dart';
import 'package:meread/global/global.dart';
import 'package:meread/models/feed.dart';

part 'post.g.dart';

/// 定义 Post 类
@collection
class Post {
  Id? id = Isar.autoIncrement;
  int feedId; // 订阅源 ID
  String title; // 标题
  String feedName; // 订阅源名称
  String link; // 链接
  String content; // 内容
  String pubDate; // 发布时间
  bool read; // 是否已读
  bool favorite; // 是否已收藏
  bool fullText; // 是否全文
  bool fullTextCache; // 是否已经有全文缓存
  int openType; // 打开方式：0阅读器 1内置标签页 2系统浏览器

  Post({
    this.id,
    required this.feedId,
    required this.title,
    required this.feedName,
    required this.link,
    required this.content,
    required this.pubDate,
    required this.read,
    required this.favorite,
    required this.fullText,
    required this.fullTextCache,
    required this.openType,
  });

  /// 查询所有 Post，按照发布时间倒序
  static Future<List<Post>> getAll() async {
    return isar.posts.where().sortByPubDateDesc().findAll();
  }

  /// 根据 List<Feed> 查询所有 Post，按照发布时间倒序
  static Future<List<Post>> getAllByFeeds(List<Feed> feeds) async {
    final List<int> feedIds = [];
    for (var feed in feeds) {
      feedIds.add(feed.id!);
    }
    final posts = await getAll();
    return posts.where((post) => feedIds.contains(post.feedId)).toList();
  }

  /// 标记所有未读 Post 为已读
  static Future<void> markAllRead(List<Post> posts) async {
    for (Post post in posts) {
      post.read = true;
    }
    await isar.writeTxn(() async {
      await isar.posts.putAll(posts);
    });
  }

  /// Post 插入数据库
  Future<void> insertToDb() async {
    /* 根据 link 判断是否重复，如果重复则不插入 */
    final List<Post> posts =
        isar.posts.where().filter().linkEqualTo(link).findAllSync();
    if (posts.isNotEmpty) {
      return;
    }
    await isar.writeTxn(() async {
      await isar.posts.put(this);
    });
  }

  /// 更新已经存在的 Post
  Future<void> updateToDb() async {
    await isar.writeTxn(() async {
      await isar.posts.put(this);
    });
  }

  /// 标记 Post 为已读
  Future<void> markAsRead() async {
    read = true;
    await isar.writeTxn(() async {
      await isar.posts.put(this);
    });
  }

  /// 标记 Post 为未读
  Future<void> markAsUnread() async {
    read = false;
    await isar.writeTxn(() async {
      await isar.posts.put(this);
    });
  }

  /// 改变 Post 的收藏状态
  Future<void> changeFavorite() async {
    favorite = !favorite;
    await isar.writeTxn(() async {
      await isar.posts.put(this);
    });
  }
}
