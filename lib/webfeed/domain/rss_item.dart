import 'package:xml/xml.dart';

import '../domain/dublin_core/dublin_core.dart';
import '../domain/itunes/itunes.dart';
import '../domain/media/media.dart';
import '../domain/rss_category.dart';
import '../domain/rss_content.dart';
import '../domain/rss_enclosure.dart';
import '../domain/rss_source.dart';
import '../util/datetime.dart';
import '../util/iterable.dart';

class RssItem {
  final String? title;
  final String? description;
  final String? link;

  final List<RssCategory>? categories;
  final String? guid;
  final DateTime? pubDate;
  final String? author;
  final String? comments;
  final RssSource? source;
  final RssContent? content;
  final Media? media;
  final RssEnclosure? enclosure;
  final DublinCore? dc;
  final Itunes? itunes;

  RssItem({
    this.title,
    this.description,
    this.link,
    this.categories,
    this.guid,
    this.pubDate,
    this.author,
    this.comments,
    this.source,
    this.content,
    this.media,
    this.enclosure,
    this.dc,
    this.itunes,
  });

  factory RssItem.parse(XmlElement element) {
    return RssItem(
      title: element.findElements('title').firstOrNull?.innerText,
      description: element.findElements('description').firstOrNull?.innerText,
      link: element.findElements('link').firstOrNull?.innerText,
      categories: element
          .findElements('category')
          .map((e) => RssCategory.parse(e))
          .toList(),
      guid: element.findElements('guid').firstOrNull?.innerText,
      pubDate:
          parseDateTime(element.findElements('pubDate').firstOrNull?.innerText),
      author: element.findElements('author').firstOrNull?.innerText,
      comments: element.findElements('comments').firstOrNull?.innerText,
      source: element
          .findElements('source')
          .map((e) => RssSource.parse(e))
          .firstOrNull,
      content: element
          .findElements('content:encoded')
          .map((e) => RssContent.parse(e))
          .firstOrNull,
      media: Media.parse(element),
      enclosure: element
          .findElements('enclosure')
          .map((e) => RssEnclosure.parse(e))
          .firstOrNull,
      dc: DublinCore.parse(element),
      itunes: Itunes.parse(element),
    );
  }
}
