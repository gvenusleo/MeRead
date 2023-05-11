import 'package:xml/xml.dart';

import '../../domain/media/category.dart';
import '../../domain/media/content.dart';
import '../../domain/media/credit.dart';
import '../../domain/media/rating.dart';
import '../../util/iterable.dart';

class Group {
  final List<Content>? contents;
  final List<Credit>? credits;
  final Category? category;
  final Rating? rating;

  Group({
    this.contents,
    this.credits,
    this.category,
    this.rating,
  });

  factory Group.parse(XmlElement element) {
    return Group(
      contents: element
          .findElements('media:content')
          .map((e) => Content.parse(e))
          .toList(),
      credits: element
          .findElements('media:credit')
          .map((e) => Credit.parse(e))
          .toList(),
      category: element
          .findElements('media:category')
          .map((e) => Category.parse(e))
          .firstOrNull,
      rating: element
          .findElements('media:rating')
          .map((e) => Rating.parse(e))
          .firstOrNull,
    );
  }
}
