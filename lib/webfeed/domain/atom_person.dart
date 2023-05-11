import 'package:xml/xml.dart';

import '../util/iterable.dart';

class AtomPerson {
  final String? name;
  final String? uri;
  final String? email;

  AtomPerson({this.name, this.uri, this.email});

  factory AtomPerson.parse(XmlElement element) {
    return AtomPerson(
      name: element.findElements('name').firstOrNull?.text,
      uri: element.findElements('uri').firstOrNull?.text,
      email: element.findElements('email').firstOrNull?.text,
    );
  }
}
