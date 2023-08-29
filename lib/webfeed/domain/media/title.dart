import 'package:xml/xml.dart';

class Title {
  final String? type;
  final String? value;

  Title({
    this.type,
    this.value,
  });

  factory Title.parse(XmlElement element) {
    return Title(
      type: element.getAttribute('type'),
      value: element.innerText,
    );
  }
}
