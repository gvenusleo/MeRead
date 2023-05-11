import 'package:xml/xml.dart';

import '../../domain/media/star_rating.dart';
import '../../domain/media/statistics.dart';
import '../../domain/media/tags.dart';
import '../../util/iterable.dart';

class Community {
  final StarRating? starRating;
  final Statistics? statistics;
  final Tags? tags;

  Community({
    this.starRating,
    this.statistics,
    this.tags,
  });

  factory Community.parse(XmlElement element) {
    return Community(
      starRating: element
          .findElements('media:starRating')
          .map((e) => StarRating.parse(e))
          .firstOrNull,
      statistics: element
          .findElements('media:statistics')
          .map((e) => Statistics.parse(e))
          .firstOrNull,
      tags: element
          .findElements('media:tags')
          .map((e) => Tags.parse(e))
          .firstOrNull,
    );
  }
}
