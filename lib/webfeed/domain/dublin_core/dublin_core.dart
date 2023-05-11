import 'package:xml/xml.dart';

import '../../util/datetime.dart';
import '../../util/iterable.dart';

class DublinCore {
  final String? title;
  final String? description;
  final String? creator;
  final String? subject;
  final String? publisher;
  final String? contributor;
  final DateTime? date;
  final DateTime? created;
  final DateTime? modified;
  final String? type;
  final String? format;
  final String? identifier;
  final String? source;
  final String? language;
  final String? relation;
  final String? coverage;
  final String? rights;

  DublinCore({
    this.title,
    this.description,
    this.creator,
    this.subject,
    this.publisher,
    this.contributor,
    this.date,
    this.created,
    this.modified,
    this.type,
    this.format,
    this.identifier,
    this.source,
    this.language,
    this.relation,
    this.coverage,
    this.rights,
  });

  factory DublinCore.parse(XmlElement element) {
    return DublinCore(
      title: element.findElements('dc:title').firstOrNull?.text,
      description: element.findElements('dc:description').firstOrNull?.text,
      creator: element.findElements('dc:creator').firstOrNull?.text,
      subject: element.findElements('dc:subject').firstOrNull?.text,
      publisher: element.findElements('dc:publisher').firstOrNull?.text,
      contributor: element.findElements('dc:contributor').firstOrNull?.text,
      date: parseDateTime(element.findElements('dc:date').firstOrNull?.text),
      created:
          parseDateTime(element.findElements('dc:created').firstOrNull?.text),
      modified:
          parseDateTime(element.findElements('dc:modified').firstOrNull?.text),
      type: element.findElements('dc:type').firstOrNull?.text,
      format: element.findElements('dc:format').firstOrNull?.text,
      identifier: element.findElements('dc:identifier').firstOrNull?.text,
      source: element.findElements('dc:source').firstOrNull?.text,
      language: element.findElements('dc:language').firstOrNull?.text,
      relation: element.findElements('dc:relation').firstOrNull?.text,
      coverage: element.findElements('dc:coverage').firstOrNull?.text,
      rights: element.findElements('dc:rights').firstOrNull?.text,
    );
  }
}
