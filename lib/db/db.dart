import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// 打开数据库，如果不存在则创建
Future<Database> openDb() async {
  return openDatabase(
    join(await getDatabasesPath(), 'meread.db'),
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE feed(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, url TEXT, description TEXT, category TEXT, fullText INTEGER, openType INTEGER)",
      );
      await db.execute(
        "CREATE TABLE post(id INTEGER PRIMARY KEY AUTOINCREMENT, feedId INTEGER, title TEXT, feedName TEXT, link TEXT, content TEXT, pubDate TEXT, read INTEGER, favorite INTEGER, openType INTEGER)",
      );
    },
    version: 1,
  );
}
