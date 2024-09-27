import 'package:dart_rss/dart_rss.dart';
import 'package:intl/intl.dart';
import 'package:meread/helpers/dio_helper.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/helpers/prefs_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';

class PostHelper {
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

  static Future<bool> _reslovePost(Feed feed) async {
    try {
      final response = await DioHelper.get(feed.url);
      final postXmlString = response.data;
      final DateTime? feedLastUpdated = IsarHelper.getFeedLatestPubDate(feed);
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
      createdAt: DateTime.now(),
    );
    post.feed.value = feed;
    IsarHelper.putPost(post);
  }

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
      createdAt: DateTime.now(),
    );
    post.feed.value = feed;
    IsarHelper.putPost(post);
  }

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
