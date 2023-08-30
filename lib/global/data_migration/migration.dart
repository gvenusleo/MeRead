import 'package:meread/global/data_migration/sqflite_util.dart';
import 'package:meread/global/global.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> migration() async {
  /* 判断 sqflite 数据库是否存在 */
  String sqfliteDbPath = join(await getDatabasesPath(), 'meread.db');
  bool sqfliteDbExist = await databaseExists(sqfliteDbPath);

  if (sqfliteDbExist) {
    /* 从 sqflite 迁移到 isar */
    List<Feed> feeds = await getAllFeedsFromSqflite();
    await isar.writeTxn(() async {
      await isar.feeds.putAll(feeds);
    });
    List<Post> posts = await getAllPostsFromSqflite(feeds);
    await isar.writeTxn(() async {
      await isar.posts.putAll(posts);
    });

    /* 删除 sqflite 数据库 */
    await deleteDatabase(sqfliteDbPath);
  }
}
