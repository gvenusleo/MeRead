import 'package:xml/xml.dart';

class RssSource {
  final String? url;
  final String? value;

  RssSource(this.url, this.value);

  factory RssSource.parse(XmlElement element) {
    var url = element.getAttribute('url');
    var value = element.text;

    return RssSource(url, value);
  }
}
