import 'package:xml/xml.dart';

class Text {
  final String? type;
  final String? lang;
  final String? start;
  final String? end;
  final String? value;

  Text({
    this.type,
    this.lang,
    this.start,
    this.end,
    this.value,
  });

  factory Text.parse(XmlElement element) {
    return Text(
      type: element.getAttribute('type'),
      lang: element.getAttribute('lang'),
      start: element.getAttribute('start'),
      end: element.getAttribute('end'),
      value: element.innerText,
    );
  }
}
