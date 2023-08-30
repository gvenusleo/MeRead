import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// 从 sqflite 数据库中获取所有 [Feed]
Future<List<Feed>> getAllFeedsFromSqflite() async {
  final Database db = await openSqfliteDb();
  final List<Map<String, dynamic>> maps = await db.query('feed');
  return List.generate(maps.length, (i) {
    return Feed(
      id: maps[i]['id'],
      name: maps[i]['name'],
      url: maps[i]['url'],
      description: maps[i]['description'],
      category: maps[i]['category'],
      fullText: maps[i]['fullText'] == 1,
      openType: maps[i]['openType'],
    );
  });
}

/// 从 sqflite 数据库中获取所有 [Post]
Future<List<Post>> getAllPostsFromSqflite(List<Feed> feeds) async {
  final Database db = await openSqfliteDb();
  final List<Map<String, dynamic>> maps = await db.query('post');
  return List.generate(maps.length, (i) {
    return Post(
      id: maps[i]['id'],
      feedId: maps[i]['feedId'],
      title: maps[i]['title'],
      feedName: maps[i]['feedName'],
      link: maps[i]['link'],
      content: maps[i]['content'],
      pubDate: maps[i]['pubDate'],
      read: maps[i]['read'] == 1,
      favorite: maps[i]['favorite'] == 1,
      fullText:
          feeds.firstWhere((feed) => feed.id == maps[i]['feedId']).fullText,
      fullTextCache: maps[i]['read'] == 2,
      openType: maps[i]['openType'],
    );
  });
}

/// 打开 sqflite 数据库
Future<Database> openSqfliteDb() async {
  return await openDatabase(
    join(await getDatabasesPath(), 'meread.db'),
    // onCreate: (db, version) async {
    //   await db.execute(
    //     "CREATE TABLE feed(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, url TEXT, description TEXT, category TEXT, fullText INTEGER, openType INTEGER)",
    //   );
    //   await db.execute(
    //     "CREATE TABLE post(id INTEGER PRIMARY KEY AUTOINCREMENT, feedId INTEGER, title TEXT, feedName TEXT, link TEXT, content TEXT, pubDate TEXT, read INTEGER, favorite INTEGER, openType INTEGER)",
    //   );
    // },
    // version: 1,
  );
}
