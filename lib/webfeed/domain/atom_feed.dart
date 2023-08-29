import 'package:xml/xml.dart';

import '../domain/atom_category.dart';
import '../domain/atom_generator.dart';
import '../domain/atom_item.dart';
import '../domain/atom_link.dart';
import '../domain/atom_person.dart';
import '../util/datetime.dart';
import '../util/iterable.dart';

class AtomFeed {
  final String? id;
  final String? title;
  final DateTime? updated;
  final List<AtomItem>? items;

  final List<AtomLink>? links;
  final List<AtomPerson>? authors;
  final List<AtomPerson>? contributors;
  final List<AtomCategory>? categories;
  final AtomGenerator? generator;
  final String? icon;
  final String? logo;
  final String? rights;
  final String? subtitle;

  AtomFeed({
    this.id,
    this.title,
    this.updated,
    this.items,
    this.links,
    this.authors,
    this.contributors,
    this.categories,
    this.generator,
    this.icon,
    this.logo,
    this.rights,
    this.subtitle,
  });

  factory AtomFeed.parse(String xmlString) {
    var document = XmlDocument.parse(xmlString);
    var feedElement = document.findElements('feed').firstOrNull;
    if (feedElement == null) {
      throw ArgumentError('feed not found');
    }

    return AtomFeed(
      id: feedElement.findElements('id').firstOrNull?.innerText,
      title: feedElement.findElements('title').firstOrNull?.innerText,
      updated: parseDateTime(
          feedElement.findElements('updated').firstOrNull?.innerText),
      items: feedElement
          .findElements('entry')
          .map((e) => AtomItem.parse(e))
          .toList(),
      links: feedElement
          .findElements('link')
          .map((e) => AtomLink.parse(e))
          .toList(),
      authors: feedElement
          .findElements('author')
          .map((e) => AtomPerson.parse(e))
          .toList(),
      contributors: feedElement
          .findElements('contributor')
          .map((e) => AtomPerson.parse(e))
          .toList(),
      categories: feedElement
          .findElements('category')
          .map((e) => AtomCategory.parse(e))
          .toList(),
      generator: feedElement
          .findElements('generator')
          .map((e) => AtomGenerator.parse(e))
          .firstOrNull,
      icon: feedElement.findElements('icon').firstOrNull?.innerText,
      logo: feedElement.findElements('logo').firstOrNull?.innerText,
      rights: feedElement.findElements('rights').firstOrNull?.innerText,
      subtitle: feedElement.findElements('subtitle').firstOrNull?.innerText,
    );
  }
}
