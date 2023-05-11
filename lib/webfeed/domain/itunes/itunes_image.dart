import 'package:xml/xml.dart';

class ItunesImage {
  final String? href;

  ItunesImage({this.href});

  factory ItunesImage.parse(XmlElement element) {
    return ItunesImage(
      href: element.getAttribute('href')?.trim(),
    );
  }
}
