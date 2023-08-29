import 'package:xml/xml.dart';

class Tags {
  final String? tags;
  final int? weight;

  Tags({
    this.tags,
    this.weight,
  });

  factory Tags.parse(XmlElement element) {
    return Tags(
      tags: element.innerText,
      weight: int.tryParse(element.getAttribute('weight') ?? '1'),
    );
  }
}
