import 'package:dart_rss/dart_rss.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meread/helpers/dio_helper.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/helpers/prefs_helper.dart';
import 'package:meread/models/category.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';

class ResolveHelper {
  /// Parse a Feed with a url.
  static Future<Feed?> parseFeed(
    String url, [
    Category? category,
    String? feedTitle,
  ]) async {
    category ??= Category(
      name: 'defaultCategory'.tr,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    try {
      final response = await DioHelper.get(url);
      final postXmlString = response.data;
      try {
        /* Parse on RSS */
        final RssFeed rssFeed = RssFeed.parse(postXmlString);
        feedTitle = rssFeed.title;
        final Feed feed = Feed(
          title: feedTitle ?? '',
          url: url,
          description: rssFeed.description ?? '',
          fullText: false,
          openType: 0,
        );
        feed.category.value = category;
        return feed;
      } catch (e) {
        /* Parse on Atom */
        final AtomFeed atomFeed = AtomFeed.parse(postXmlString);
        final Feed feed = Feed(
          title: atomFeed.title ?? '',
          url: url,
          description: atomFeed.subtitle ?? '',
          fullText: false,
          openType: 0,
        );
        feed.category.value = category;
        return feed;
      }
    } catch (e) {
      LogHelper.e('[feed] Parse Feed Error: $e');
      return null;
    }
  }

  /// Parse List<Feed>
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

  /// Parse a Feed to get update
  static Future<bool> _reslovePost(Feed feed) async {
    try {
      final response = await DioHelper.get(feed.url);
      final postXmlString = response.data;
      final DateTime? feedLastUpdated = await IsarHelper.getLatesPubDate(feed);
      try {
        RssFeed rssFeed = RssFeed.parse(postXmlString);
        for (RssItem item in rssFeed.items) {
          if (!(_parsePubDate(item.pubDate)
              .isAfter(feedLastUpdated ?? DateTime(0)))) {
            break;
          }
          _parseRSSPostItem(item, feed);
        }
        return true;
      } catch (e) {
        AtomFeed atomFeed = AtomFeed.parse(postXmlString);
        for (AtomItem item in atomFeed.items) {
          if (!(_parsePubDate(item.updated)
              .isAfter(feedLastUpdated ?? DateTime(0)))) {
            break;
          }
          _parseAtomPostItem(item, feed);
        }
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  /// Use RSS to parse RssItem and save to database
  static void _parseRSSPostItem(RssItem item, Feed feed) {
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
    IsarHelper.savePost(post);
  }

  /// Use Atom to parse RssItem and save to database
  static void _parseAtomPostItem(AtomItem item, Feed feed) {
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
    IsarHelper.savePost(post);
  }

  /// Determine whether the Post is blocked by title and content
  static bool _isBlock(String title, String content) {
    List<String> blockList = PrefsHelper.blockList;
    bool blockStatue = false;
    for (String block in blockList) {
      if (title.contains(block) || content.contains(block)) {
        blockStatue = true;
        break;
      }
    }
    return blockStatue;
  }

  /// Post pubDate format conversion
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
