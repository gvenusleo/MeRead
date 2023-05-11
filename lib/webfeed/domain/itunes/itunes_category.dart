import 'package:xml/xml.dart';

class ItunesCategory {
  final String? category;
  final List<String>? subCategories;

  ItunesCategory({this.category, this.subCategories});

  factory ItunesCategory.parse(XmlElement element) {
    return ItunesCategory(
        category: element.getAttribute('text')?.trim(),
        subCategories: element
            .findElements('itunes:category')
            .map((e) => e.getAttribute('text')?.trim() ?? '')
            .toList());
  }
}
