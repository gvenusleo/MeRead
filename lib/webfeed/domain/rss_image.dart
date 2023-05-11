import 'package:xml/xml.dart';

import '../util/iterable.dart';

class RssImage {
  final String? title;
  final String? url;
  final String? link;

  RssImage({this.title, this.url, this.link});

  factory RssImage.parse(XmlElement element) {
    return RssImage(
      title: element.findElements('title').firstOrNull?.text,
      url: element.findElements('url').firstOrNull?.text,
      link: element.findElements('link').firstOrNull?.text,
    );
  }
}
