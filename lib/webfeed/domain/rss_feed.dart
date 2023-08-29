import 'dart:core';

import 'package:xml/xml.dart';

import 'dublin_core/dublin_core.dart';
import 'itunes/itunes.dart';
import 'rss_category.dart';
import 'rss_cloud.dart';
import 'rss_image.dart';
import 'rss_item.dart';
import 'syndication/syndication.dart';
import '../util/iterable.dart';

class RssFeed {
  final String? title;
  final String? author;
  final String? description;
  final String? link;
  final List<RssItem>? items;

  final RssImage? image;
  final RssCloud? cloud;
  final List<RssCategory>? categories;
  final List<String>? skipDays;
  final List<int>? skipHours;
  final String? lastBuildDate;
  final String? language;
  final String? generator;
  final String? copyright;
  final String? docs;
  final String? managingEditor;
  final String? rating;
  final String? webMaster;
  final int? ttl;
  final DublinCore? dc;
  final Itunes? itunes;
  final Syndication? syndication;

  RssFeed({
    this.title,
    this.author,
    this.description,
    this.link,
    this.items,
    this.image,
    this.cloud,
    this.categories,
    this.skipDays,
    this.skipHours,
    this.lastBuildDate,
    this.language,
    this.generator,
    this.copyright,
    this.docs,
    this.managingEditor,
    this.rating,
    this.webMaster,
    this.ttl,
    this.dc,
    this.itunes,
    this.syndication,
  });

  factory RssFeed.parse(String xmlString) {
    var document = XmlDocument.parse(xmlString);
    var rss = document.findElements('rss').firstOrNull;
    var rdf = document.findElements('rdf:RDF').firstOrNull;
    if (rss == null && rdf == null) {
      throw ArgumentError('not a rss feed');
    }
    var channelElement = (rss ?? rdf)!.findElements('channel').firstOrNull;
    if (channelElement == null) {
      throw ArgumentError('channel not found');
    }
    return RssFeed(
      title: channelElement.findElements('title').firstOrNull?.innerText,
      author: channelElement.findElements('author').firstOrNull?.innerText,
      description:
          channelElement.findElements('description').firstOrNull?.innerText,
      link: channelElement.findElements('link').firstOrNull?.innerText,
      items: (rdf ?? channelElement)
          .findElements('item')
          .map((e) => RssItem.parse(e))
          .toList(),
      image: (rdf ?? channelElement)
          .findElements('image')
          .map((e) => RssImage.parse(e))
          .firstOrNull,
      cloud: channelElement
          .findElements('cloud')
          .map((e) => RssCloud.parse(e))
          .firstOrNull,
      categories: channelElement
          .findElements('category')
          .map((e) => RssCategory.parse(e))
          .toList(),
      skipDays: channelElement
              .findElements('skipDays')
              .firstOrNull
              ?.findAllElements('day')
              .map((e) => e.innerText)
              .toList() ??
          [],
      skipHours: channelElement
              .findElements('skipHours')
              .firstOrNull
              ?.findAllElements('hour')
              .map((e) => int.tryParse(e.innerText) ?? 0)
              .toList() ??
          [],
      lastBuildDate:
          channelElement.findElements('lastBuildDate').firstOrNull?.innerText,
      language: channelElement.findElements('language').firstOrNull?.innerText,
      generator:
          channelElement.findElements('generator').firstOrNull?.innerText,
      copyright:
          channelElement.findElements('copyright').firstOrNull?.innerText,
      docs: channelElement.findElements('docs').firstOrNull?.innerText,
      managingEditor:
          channelElement.findElements('managingEditor').firstOrNull?.innerText,
      rating: channelElement.findElements('rating').firstOrNull?.innerText,
      webMaster:
          channelElement.findElements('webMaster').firstOrNull?.innerText,
      ttl: int.tryParse(
          channelElement.findElements('ttl').firstOrNull?.innerText ?? '0'),
      dc: DublinCore.parse(channelElement),
      itunes: Itunes.parse(channelElement),
      syndication: Syndication.parse(channelElement),
    );
  }
}
