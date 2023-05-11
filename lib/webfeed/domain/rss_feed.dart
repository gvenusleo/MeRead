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
      title: channelElement.findElements('title').firstOrNull?.text,
      author: channelElement.findElements('author').firstOrNull?.text,
      description: channelElement.findElements('description').firstOrNull?.text,
      link: channelElement.findElements('link').firstOrNull?.text,
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
              .map((e) => e.text)
              .toList() ??
          [],
      skipHours: channelElement
              .findElements('skipHours')
              .firstOrNull
              ?.findAllElements('hour')
              .map((e) => int.tryParse(e.text) ?? 0)
              .toList() ??
          [],
      lastBuildDate:
          channelElement.findElements('lastBuildDate').firstOrNull?.text,
      language: channelElement.findElements('language').firstOrNull?.text,
      generator: channelElement.findElements('generator').firstOrNull?.text,
      copyright: channelElement.findElements('copyright').firstOrNull?.text,
      docs: channelElement.findElements('docs').firstOrNull?.text,
      managingEditor:
          channelElement.findElements('managingEditor').firstOrNull?.text,
      rating: channelElement.findElements('rating').firstOrNull?.text,
      webMaster: channelElement.findElements('webMaster').firstOrNull?.text,
      ttl: int.tryParse(
          channelElement.findElements('ttl').firstOrNull?.text ?? '0'),
      dc: DublinCore.parse(channelElement),
      itunes: Itunes.parse(channelElement),
      syndication: Syndication.parse(channelElement),
    );
  }
}
