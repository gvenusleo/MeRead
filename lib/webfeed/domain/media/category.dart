import 'package:xml/xml.dart';

class Category {
  final String? scheme;
  final String? label;
  final String? value;

  Category({
    this.scheme,
    this.label,
    this.value,
  });

  factory Category.parse(XmlElement element) {
    return Category(
      scheme: element.getAttribute('scheme'),
      label: element.getAttribute('label'),
      value: element.text,
    );
  }
}
