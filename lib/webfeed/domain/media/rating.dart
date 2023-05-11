import 'package:xml/xml.dart';

class Rating {
  final String? scheme;
  final String? value;

  Rating({
    this.scheme,
    this.value,
  });

  factory Rating.parse(XmlElement element) {
    return Rating(
      scheme: element.getAttribute('scheme'),
      value: element.text,
    );
  }
}
