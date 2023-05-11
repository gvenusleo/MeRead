import 'package:xml/xml.dart';

class Description {
  final String? type;
  final String? value;

  Description({
    this.type,
    this.value,
  });

  factory Description.parse(XmlElement element) {
    return Description(
      type: element.getAttribute('type'),
      value: element.text,
    );
  }
}
