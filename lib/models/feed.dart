// 定义 Feed 类
import 'package:sqflite/sqflite.dart';

import '../data/db.dart';

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
}
