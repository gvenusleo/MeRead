import 'package:dart_rss/dart_rss.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:meread/common/global.dart';
import 'package:meread/common/helpers/feed_helper.dart';
import 'package:meread/common/helpers/prefs_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';

class PostHelper {
  /// 保存 Post 到 Isar
  static Future<void> savePost(Post post) async {
    isar.writeTxnSync(() {
      isar.posts.putSync(post);
    });
  }

  /// 解析 List<Feed> 返回总数量和失败数量
  static Future<List<int>> reslovePosts(List<Feed> feeds) async {
    int errorCount = 0;
    for (final Feed feed in feeds) {
      bool res = await _reslovePost(feed);
      if (!res) {
        errorCount++;
      }
    }
    return [feeds.length, errorCount];
  }

  /// 获取所有 Post
  static Future<List<Post>> getAllPosts() async {
    return await isar.posts.where().findAll();
  }

  /// 通过 List<Feed> 从 Isar 数据库获取关联的 Post
  static Future<List<Post>> getPostsByFeeds(List<Feed> feeds) async {
    final List<Post> result = [];
    for (final Feed feed in feeds) {
      final List<Post> posts = await isar.posts
          .where()
          .filter()
          .feed((f) => f.idEqualTo(feed.id))
          .findAll();
      result.addAll(posts);
    }
    return result;
  }

  /// 从 title 和 content 中搜索
  static Future<List<Post>> search(String value) async {
    if (value.isEmpty) {
      return [];
    }
    final List<Post> result = await isar.posts
        .where()
        .filter()
        .titleContains(value)
        .or()
        .contentContains(value)
        .findAll();
    return result;
  }

  /// 删除所有 feed 为指定 Feed 的 Post
  static Future<void> deletePostsByFeed(Feed feed) async {
    final List<Post> posts = await getPostsByFeeds([feed]);
    await isar.writeTxn(() async {
      await isar.posts.deleteAll(posts.map((e) => e.id!).toList());
    });
  }

  /// 修改 Post 阅读状态
  static Future<void> updatePostReadStatus(Post post, {bool? read}) async {
    post.read = read ?? !post.read;
    await savePost(post);
  }

  /// 全标已读
  static Future<void> mardPostsAsRead(List<Post> posts) async {
    for (final Post post in posts) {
      post.read = true;
    }
    await isar.writeTxn(() async {
      await isar.posts.putAll(posts);
    });
  }

  /// 解析 Feed, 获取更新
  static Future<bool> _reslovePost(Feed feed) async {
    try {
      final Dio dio = appDio.dio;
      final response = await dio.get(feed.url);
      final postXmlString = response.data;
      final DateTime? feedLastUpdated = await FeedHelper.getLatesPubDate(feed);
      try {
        /* 使用 RSS 格式解析 */
        RssFeed rssFeed = RssFeed.parse(postXmlString);
        List<Future> futures = [];
        for (RssItem item in rssFeed.items) {
          if (!(_parsePubDate(item.pubDate)
              .isAfter(feedLastUpdated ?? DateTime(0)))) {
            break;
          }
          futures.add(_parseRSSPostItem(item, feed));
        }
        await Future.wait(futures);
        return true;
      } catch (e) {
        /* 使用 Atom 格式解析 */
        AtomFeed atomFeed = AtomFeed.parse(postXmlString);
        List<Future> futures = [];
        for (AtomItem item in atomFeed.items) {
          if (!(_parsePubDate(item.updated)
              .isAfter(feedLastUpdated ?? DateTime(0)))) {
            break;
          }
          futures.add(_parseAtomPostItem(item, feed));
        }
        await Future.wait(futures);
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  /// 使用 RSS 格式解析 [RssItem]，存入数据库
  static Future<void> _parseRSSPostItem(RssItem item, Feed feed) async {
    /* 判断是否屏蔽 */
    String title = item.title!.trim();
    bool blockStatue = _isBlock(title, item.description ?? '');
    if (blockStatue) {
      return;
    }
    Post post = Post(
      title: title,
      link: item.link!,
      content: item.description ?? '',
      pubDate: _parsePubDate(item.pubDate),
      read: false,
      favorite: false,
      fullText: feed.fullText,
    );
    post.feed.value = feed;
    await savePost(post);
  }

  /// 使用 RSS 格式解析 [AtomItem]，存入数据库
  static Future<void> _parseAtomPostItem(AtomItem item, Feed feed) async {
    /* 判断是否屏蔽 */
    String title = item.title!.trim();
    bool blockStatue = _isBlock(title, item.content ?? '');
    if (blockStatue) {
      return;
    }
    Post post = Post(
      title: title,
      link: item.links[0].href!,
      content: item.content!,
      pubDate: _parsePubDate(item.updated),
      read: false,
      favorite: false,
      fullText: feed.fullText,
    );
    post.feed.value = feed;
    await savePost(post);
  }

  /// 通过 title 判断 [Post] 是否屏蔽
  static bool _isBlock(String postTitle, String content) {
    List<String> blockList = PrefsHelper.blockList;
    bool blockStatue = false;
    for (String block in blockList) {
      if (postTitle.contains(block) || content.contains(block)) {
        blockStatue = true;
        break;
      }
    }
    return blockStatue;
  }

  /// Post pubDate 格式转换
  static DateTime _parsePubDate(String? str) {
    if (str == null) {
      return DateTime.now();
    }
    const dateFormatPatterns = [
      'EEE, d MMM yyyy HH:mm:ss Z',
    ];
    try {
      return DateTime.parse(str);
    } catch (_) {
      for (final pattern in dateFormatPatterns) {
        try {
          final format = DateFormat(pattern);
          return format.parse(str);
        } catch (_) {}
      }
    }
    return DateTime.now();
  }
}
