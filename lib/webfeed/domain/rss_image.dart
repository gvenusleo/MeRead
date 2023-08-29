import 'package:xml/xml.dart';

import '../util/iterable.dart';

class RssImage {
  final String? title;
  final String? url;
  final String? link;

  RssImage({this.title, this.url, this.link});

  factory RssImage.parse(XmlElement element) {
    return RssImage(
      title: element.findElements('title').firstOrNull?.innerText,
      url: element.findElements('url').firstOrNull?.innerText,
      link: element.findElements('link').firstOrNull?.innerText,
    );
  }
}
