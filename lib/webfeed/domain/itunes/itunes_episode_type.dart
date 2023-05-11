import 'package:xml/xml.dart';

enum ItunesEpisodeType { full, trailer, bonus, unknown }

ItunesEpisodeType newItunesEpisodeType(XmlElement element) {
  switch (element.text) {
    case 'full':
      return ItunesEpisodeType.full;
    case 'trailer':
      return ItunesEpisodeType.trailer;
    case 'bonus':
      return ItunesEpisodeType.bonus;
    default:
      return ItunesEpisodeType.unknown;
  }
}
