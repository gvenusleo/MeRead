import 'package:meread/db/db.dart';
import 'package:meread/models/post.dart';
import 'package:sqflite/sqflite.dart';

// 定义 Feed 类
class Feed {
  int? id;
  String name; // 订阅源名称
  String url; // 订阅源地址
  String description; // 订阅源描述
  String category; // 订阅源分类
  int fullText; // 是否全文：0否 1是
  int openType; // 打开方式：0阅读器 1内置标签页 2系统浏览器

  Feed({
    this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.category,
    required this.fullText,
    required this.openType,
  });

  factory Feed.fromMap(Map<String, dynamic> map) {
    return Feed(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      description: map['description'],
      category: map['category'],
      fullText: map['fullText'],
      openType: map['openType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'description': description,
      'category': category,
      'fullText': fullText,
      'openType': openType,
    };
  }

  // 根据 url 判断 Feed 是否已存在
  static isExist(String url) async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'feed',
      where: "url = ?",
      whereArgs: [url],
    );
    return maps.isNotEmpty;
  }

  // 将 Feed 插入数据库
  Future<void> insertToDb() async {
    final Database db = await openDb();
    await db.insert(
      'feed',
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 更新 Feed
  Future<void> updateToDb() async {
    final Database db = await openDb();
    await db.update(
      'feed',
      toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // 删除 Feed
  Future<void> deleteFromDb() async {
    final Database db = await openDb();
    await db.delete(
      'feed',
      where: "id = ?",
      whereArgs: [id],
    );
    // 删除 Feed 时，同时删除该 Feed 下的所有文章
    await db.delete(
      'post',
      where: "feedId = ?",
      whereArgs: [id],
    );
  }

  // 更新 Feed 下所有 Post 中的 feedName
  Future<void> updatePostFeedName() async {
    final db = await openDb();
    await db.update(
      'post',
      {'feedName': name},
      where: "feedId = ?",
      whereArgs: [id],
    );
  }

  // 更改 Feed 下所有 Post 的 openType
  Future<void> updatePostsOpenType() async {
    final db = await openDb();
    await db.update(
      'post',
      {'openType': openType},
      where: "feedId = ?",
      whereArgs: [id],
    );
  }

  // 查询所有 Feed
  static Future<List<Feed>> getAll() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('feed');
    return List.generate(maps.length, (i) {
      return Feed.fromMap(maps[i]);
    });
  }

  // 查询所有 Feed 并按分类分组
  static Future<Map<String, List<Feed>>> groupByCategory() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('feed');
    List<Feed> feeds = List.generate(maps.length, (i) {
      return Feed.fromMap(maps[i]);
    });
    Map<String, List<Feed>> feedsGroupByCategory = {};
    for (var feed in feeds) {
      if (feedsGroupByCategory[feed.category] == null) {
        feedsGroupByCategory[feed.category] = [];
      }
      feedsGroupByCategory[feed.category]!.add(feed);
    }
    return feedsGroupByCategory;
  }

  // 查询 Feed 下的所有 Post，按照发布时间倒序
  Future<List<Post>> getAllPosts() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      where: "feedId = ?",
      whereArgs: [id],
      orderBy: 'pubDate DESC',
    );
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  // 查询 Feed 下所有未读 Post
  Future<List<Post>> getUnreadPosts() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      where: "feedId = ? AND read = ?",
      whereArgs: [id, 0],
      orderBy: 'pubDate DESC',
    );
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  // 将 Feed 下所有 Post 标记为已读
  Future<void> markPostsAsRead() async {
    final db = await openDb();
    await db.update(
      'post',
      {'read': 1},
      where: "feedId = ? AND read = ?",
      whereArgs: [id, 0],
    );
  }

  // 查询 Feed 下所有收藏 Post
  Future<List<Post>> getAllfavoritePosts() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      where: "feedId = ? AND favorite = ?",
      whereArgs: [id, 1],
      orderBy: 'pubDate DESC',
    );
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  // 获取 Feed 下最新的 Post 的 pubDate
  Future<String?> getLatesPubDate() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      where: "feedId = ?",
      whereArgs: [id],
      orderBy: 'pubDate DESC',
      limit: 1,
    );
    if (maps.isEmpty) {
      return null;
    }
    return maps[0]['pubDate'];
  }

  // 查询所有 Feed 未读 Post 数量，返回一个 Map
  static Future<Map<int, int>> unreadPostCount() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('feed');
    final Map<int, int> unreadPostCount = {};
    for (var i = 0; i < maps.length; i++) {
      final int feedId = maps[i]['id'];
      final List<Map<String, dynamic>> postMaps = await db.query(
        'post',
        where: "feedId = ? AND read = ?",
        whereArgs: [feedId, 0],
      );
      unreadPostCount[feedId] = postMaps.length;
    }
    return unreadPostCount;
  }
}
