import 'package:xml/xml.dart';

import '../domain/atom_category.dart';
import '../domain/atom_link.dart';
import '../domain/atom_person.dart';
import '../domain/atom_source.dart';
import '../domain/media/media.dart';
import '../util/datetime.dart';
import '../util/iterable.dart';

class AtomItem {
  final String? id;
  final String? title;
  final DateTime? updated;

  final List<AtomPerson>? authors;
  final List<AtomLink>? links;
  final List<AtomCategory>? categories;
  final List<AtomPerson>? contributors;
  final AtomSource? source;
  final String? published;
  final String? content;
  final String? summary;
  final String? rights;
  final Media? media;

  AtomItem({
    this.id,
    this.title,
    this.updated,
    this.authors,
    this.links,
    this.categories,
    this.contributors,
    this.source,
    this.published,
    this.content,
    this.summary,
    this.rights,
    this.media,
  });

  factory AtomItem.parse(XmlElement element) {
    return AtomItem(
      id: element.findElements('id').firstOrNull?.innerText,
      title: element.findElements('title').firstOrNull?.innerText,
      updated:
          parseDateTime(element.findElements('updated').firstOrNull?.innerText),
      authors: element
          .findElements('author')
          .map((e) => AtomPerson.parse(e))
          .toList(),
      links:
          element.findElements('link').map((e) => AtomLink.parse(e)).toList(),
      categories: element
          .findElements('category')
          .map((e) => AtomCategory.parse(e))
          .toList(),
      contributors: element
          .findElements('contributor')
          .map((e) => AtomPerson.parse(e))
          .toList(),
      source: element
          .findElements('source')
          .map((e) => AtomSource.parse(e))
          .firstOrNull,
      published: element.findElements('published').firstOrNull?.innerText,
      content: element.findElements('content').firstOrNull?.innerText,
      summary: element.findElements('summary').firstOrNull?.innerText,
      rights: element.findElements('rights').firstOrNull?.innerText,
      media: Media.parse(element),
    );
  }
}
