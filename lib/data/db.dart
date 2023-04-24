import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/feed.dart';
import '../models/post.dart';
import 'setting.dart';

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

// 将 Feed 插入数据库
Future<void> insertFeed(Feed feed) async {
  final Database db = await openDb();
  await db.insert(
    'feed',
    feed.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// 查询所有 Feed
Future<List<Feed>> feeds() async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query('feed');
  return List.generate(maps.length, (i) {
    return Feed(
      id: maps[i]['id'],
      name: maps[i]['name'],
      url: maps[i]['url'],
      description: maps[i]['description'],
      category: maps[i]['category'],
      fullText: maps[i]['fullText'],
      openType: maps[i]['openType'],
    );
  });
}

// 修改 Feed
Future<void> updateFeed(Feed feed) async {
  final db = await openDb();
  await db.update(
    'feed',
    feed.toMap(),
    where: "id = ?",
    whereArgs: [feed.id],
  );
}

// 根据 url 查询 Feed 是否存在
Future<bool> feedExist(String url) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'feed',
    where: "url = ?",
    whereArgs: [url],
  );
  return maps.isNotEmpty;
}

// 查询所有 Feed 并按分类分组
Future<Map<String, List<Feed>>> feedsGroupByCategory() async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query('feed');
  List<Feed> feeds = List.generate(maps.length, (i) {
    return Feed(
      id: maps[i]['id'],
      name: maps[i]['name'],
      url: maps[i]['url'],
      description: maps[i]['description'],
      category: maps[i]['category'],
      fullText: maps[i]['fullText'],
      openType: maps[i]['openType'],
    );
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

// 删除 Feed
Future<void> deleteFeed(int id) async {
  final db = await openDb();
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

// 根据 Feed id 查询 Feed 的 Category
Future<String> feedCategory(int id) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'feed',
    where: "id = ?",
    whereArgs: [id],
  );
  return maps[0]['category'];
}

// 更新 Feed 下所有 Post 中的 feedName
Future<void> updatePostFeedName(int id, String name) async {
  final db = await openDb();
  await db.update(
    'post',
    {'feedName': name},
    where: "feedId = ?",
    whereArgs: [id],
  );
}

// 根据 id 查询 Feed 的 openType
Future<int> feedOpenType(int id) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'feed',
    where: "id = ?",
    whereArgs: [id],
  );
  return maps[0]['openType'];
}

// 根据 id 查询 Feed 的 fullText
Future<int> feedFullText(int id) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'feed',
    where: "id = ?",
    whereArgs: [id],
  );
  return maps[0]['fullText'];
}

// 将 Post 插入数据库
Future<void> insertPost(Post post) async {
  final Database db = await openDb();
  bool allowDup = await getAllowDuplicate();
  if (allowDup) {
    await db.insert(
      'post',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    // 根据 link 判断是否重复，如果重复则不插入
    final List<Map<String, dynamic>> maps = await db.query(
      'post',
      where: "link = ?",
      whereArgs: [post.link],
    );
    if (maps.isEmpty) {
      await db.insert(
        'post',
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}

// 查询所有 Post，按照发布时间倒序
Future<List<Post>> posts() async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'post',
    orderBy: 'pubDate DESC',
  );
  return List.generate(maps.length, (i) {
    return Post(
      id: maps[i]['id'],
      feedId: maps[i]['feedId'],
      title: maps[i]['title'],
      feedName: maps[i]['feedName'],
      link: maps[i]['link'],
      content: maps[i]['content'],
      pubDate: maps[i]['pubDate'],
      read: maps[i]['read'],
      favorite: maps[i]['favorite'],
      openType: maps[i]['openType'],
    );
  });
}

// 查询所有未读 Post
Future<List<Post>> unreadPosts() async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'post',
    where: "read = ?",
    whereArgs: [0],
    orderBy: 'pubDate DESC',
  );
  return List.generate(maps.length, (i) {
    return Post(
      id: maps[i]['id'],
      feedId: maps[i]['feedId'],
      title: maps[i]['title'],
      feedName: maps[i]['feedName'],
      link: maps[i]['link'],
      content: maps[i]['content'],
      pubDate: maps[i]['pubDate'],
      read: maps[i]['read'],
      favorite: maps[i]['favorite'],
      openType: maps[i]['openType'],
    );
  });
}

// 修改 Post
Future<void> updatePost(Post post) async {
  final db = await openDb();
  await db.update(
    'post',
    post.toMap(),
    where: "id = ?",
    whereArgs: [post.id],
  );
}

// 查询 Feed 下所有未读 Post
Future<List<Post>> unreadPostsByFeedId(int feedId) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'post',
    where: "feedId = ? AND read = ?",
    whereArgs: [feedId, 0],
    orderBy: 'pubDate DESC',
  );
  return List.generate(maps.length, (i) {
    return Post(
      id: maps[i]['id'],
      feedId: maps[i]['feedId'],
      title: maps[i]['title'],
      feedName: maps[i]['feedName'],
      link: maps[i]['link'],
      content: maps[i]['content'],
      pubDate: maps[i]['pubDate'],
      read: maps[i]['read'],
      favorite: maps[i]['favorite'],
      openType: maps[i]['openType'],
    );
  });
}

// 查询 Feed 下的所有 Post，按照发布时间倒序
Future<List<Post>> postsByFeedId(int feedId) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'post',
    where: "feedId = ?",
    whereArgs: [feedId],
    orderBy: 'pubDate DESC',
  );
  return List.generate(maps.length, (i) {
    return Post(
      id: maps[i]['id'],
      feedId: maps[i]['feedId'],
      title: maps[i]['title'],
      feedName: maps[i]['feedName'],
      link: maps[i]['link'],
      content: maps[i]['content'],
      pubDate: maps[i]['pubDate'],
      read: maps[i]['read'],
      favorite: maps[i]['favorite'],
      openType: maps[i]['openType'],
    );
  });
}

// 将 Feed 下所有 Post 标记为已读
Future<void> markFeedPostsAsRead(int feedId) async {
  final db = await openDb();
  await db.update(
    'post',
    {'read': 1},
    where: "feedId = ?",
    whereArgs: [feedId],
  );
}

// 将所有 Post.read = 1，如果 Post.read = 2 则不修改
Future<void> markAllPostsAsRead() async {
  final db = await openDb();
  await db.update(
    'post',
    {'read': 1},
    where: "read = ?",
    whereArgs: [0],
  );
}

// 标记单一 Post 为已读
Future<void> markPostAsRead(int id) async {
  final db = await openDb();
  await db.update(
    'post',
    {'read': 1},
    where: "id = ?",
    whereArgs: [id],
  );
}

// 标记单一 Post 为未读
Future<void> markPostAsUnread(int id) async {
  final db = await openDb();
  await db.update(
    'post',
    {'read': 0},
    where: "id = ?",
    whereArgs: [id],
  );
}

// 更改 Feed 下所有 Post 的 openType
Future<void> updateFeedPostsOpenType(int feedId, int openType) async {
  final db = await openDb();
  await db.update(
    'post',
    {'openType': openType},
    where: "feedId = ?",
    whereArgs: [feedId],
  );
}

// 查询所有 Feed 下的所有 Post
// 如果数量超过 feedMaxSaveCount
// 则删除最早的 Post，使得数量等于 feedMaxSaveCount
Future<void> checkPostCount(int feedMaxSaveCount) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query('feed');
  for (var i = 0; i < maps.length; i++) {
    final int feedId = maps[i]['id'];
    final List<Map<String, dynamic>> postMaps = await db.query(
      'post',
      where: "feedId = ?",
      whereArgs: [feedId],
      orderBy: 'pubDate ASC',
    );
    if (postMaps.length > feedMaxSaveCount) {
      final int deleteCount = postMaps.length - feedMaxSaveCount;
      final List<int> ids = [];
      for (var j = 0; j < deleteCount; j++) {
        ids.add(postMaps[j]['id']);
      }
      await db.delete(
        'post',
        where: "id IN (${ids.join(',')})",
      );
    }
  }
}

// 查询单一 Feed 下的所有 Post
// 如果数量超过 feedMaxSaveCount
// 则删除最早的 Post，使得数量等于 feedMaxSaveCount
Future<void> checkPostCountByFeed(int feedId, int feedMaxSaveCount) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> postMaps = await db.query(
    'post',
    where: "feedId = ?",
    whereArgs: [feedId],
    orderBy: 'pubDate ASC',
  );
  if (postMaps.length > feedMaxSaveCount) {
    final int deleteCount = postMaps.length - feedMaxSaveCount;
    final List<int> ids = [];
    for (var j = 0; j < deleteCount; j++) {
      ids.add(postMaps[j]['id']);
    }
    await db.delete(
      'post',
      where: "id IN (${ids.join(',')})",
    );
  }
}

// 改变 Post 的收藏状态
Future<void> changePostFavorite(int id) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'post',
    where: "id = ?",
    whereArgs: [id],
  );
  final int favorite = maps[0]['favorite'];
  await db.update(
    'post',
    {'favorite': favorite == 0 ? 1 : 0},
    where: "id = ?",
    whereArgs: [id],
  );
}

// 查询所有收藏 Post
Future<List<Post>> favoritePosts() async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'post',
    where: "favorite = ?",
    whereArgs: [1],
    orderBy: 'pubDate DESC',
  );
  return List.generate(maps.length, (i) {
    return Post(
      id: maps[i]['id'],
      feedId: maps[i]['feedId'],
      title: maps[i]['title'],
      feedName: maps[i]['feedName'],
      link: maps[i]['link'],
      content: maps[i]['content'],
      pubDate: maps[i]['pubDate'],
      read: maps[i]['read'],
      favorite: maps[i]['favorite'],
      openType: maps[i]['openType'],
    );
  });
}

// 查询 Feed 下所有收藏 Post
Future<List<Post>> favoritePostsByFeedId(int feedId) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'post',
    where: "feedId = ? AND favorite = ?",
    whereArgs: [feedId, 1],
    orderBy: 'pubDate DESC',
  );
  return List.generate(maps.length, (i) {
    return Post(
      id: maps[i]['id'],
      feedId: maps[i]['feedId'],
      title: maps[i]['title'],
      feedName: maps[i]['feedName'],
      link: maps[i]['link'],
      content: maps[i]['content'],
      pubDate: maps[i]['pubDate'],
      read: maps[i]['read'],
      favorite: maps[i]['favorite'],
      openType: maps[i]['openType'],
    );
  });
}

// 获取 Feed 下最新的 Post 的 pubDate
Future<String?> getFeedLatestPostPubDate(int feedId) async {
  final Database db = await openDb();
  final List<Map<String, dynamic>> maps = await db.query(
    'post',
    where: "feedId = ?",
    whereArgs: [feedId],
    orderBy: 'pubDate DESC',
    limit: 1,
  );
  if (maps.isEmpty) {
    return null;
  }
  return maps[0]['pubDate'];
}

// 查询所有 Feed 未读 Post 数量，返回一个 Map
Future<Map<int, int>> unreadPostCount() async {
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
