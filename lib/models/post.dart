// 定义 Post 类
import 'package:sqflite/sqflite.dart';

import '../db/db.dart';

class Post {
  int? id;
  int feedId; // 订阅源 ID
  String title; // 标题
  String feedName; // 订阅源名称
  String link; // 链接
  String content; // 内容
  String pubDate; // 发布时间
  int read; // 是否已读：0未读 1已读 2已读且已获取全文
  int favorite; // 是否已收藏：0否 1是
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
    required this.openType,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      feedId: map['feedId'],
      title: map['title'],
      feedName: map['feedName'],
      link: map['link'],
      content: map['content'],
      pubDate: map['pubDate'],
      read: map['read'],
      favorite: map['favorite'],
      openType: map['openType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'feedId': feedId,
      'title': title,
      'feedName': feedName,
      'link': link,
      'content': content,
      'pubDate': pubDate,
      'read': read,
      'favorite': favorite,
      'openType': openType,
    };
  }

  // 将 Post 插入数据库
  Future<void> insertToDb() async {
    final Database db = await openDb();
    // 根据 link 判断是否重复，如果重复则不插入
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      where: "link = ?",
      whereArgs: [link],
    );
    if (maps.isEmpty) {
      await db.insert(
        'post',
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // 修改 Post
  Future<void> updateToDb() async {
    final Database db = await openDb();
    await db.update(
      'post',
      toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // 标记 Post 为已读
  Future<void> markRead() async {
    final Database db = await openDb();
    await db.update(
      'post',
      {'read': 1},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // 标记 Post 为未读
  Future<void> markUnread() async {
    final Database db = await openDb();
    await db.update(
      'post',
      {'read': 0},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // 改变 Post 的收藏状态
  Future<void> changeFavorite() async {
    final Database db = await openDb();
    await db.update(
      'post',
      {'favorite': favorite},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // 查询所有 Post，按照发布时间倒序
  static Future<List<Post>> getAll() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      orderBy: 'pubDate DESC',
    );
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  // 根据 Feed.id 查询 Feed 的 fullText
  Future<int> getFullText() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'feed',
      where: "id = ?",
      whereArgs: [feedId],
    );
    return maps[0]['fullText'];
  }

  // 查询所有未读 Post
  static Future<List<Post>> getUnread() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      where: "read = ?",
      whereArgs: [0],
      orderBy: 'pubDate DESC',
    );
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  // 标记所有未读 Post 为已读
  static Future<void> markAllRead() async {
    final Database db = await openDb();
    await db.update(
      'post',
      {'read': 1},
      where: "read = ?",
      whereArgs: [0],
    );
  }

  // 查询所有收藏 Post
  static Future<List<Post>> getAllFavorite() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      where: "favorite = ?",
      whereArgs: [1],
      orderBy: 'pubDate DESC',
    );
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }
}
