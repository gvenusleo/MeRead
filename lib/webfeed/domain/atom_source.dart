import 'package:xml/xml.dart';

import '../util/iterable.dart';

class AtomSource {
  final String? id;
  final String? title;
  final String? updated;

  AtomSource({
    this.id,
    this.title,
    this.updated,
  });

  factory AtomSource.parse(XmlElement element) {
    return AtomSource(
      id: element.findElements('id').firstOrNull?.text,
      title: element.findElements('title').firstOrNull?.text,
      updated: element.findElements('updated').firstOrNull?.text,
    );
  }
}
