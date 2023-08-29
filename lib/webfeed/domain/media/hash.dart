import 'package:xml/xml.dart';

class Hash {
  final String? algo;
  final String? value;

  Hash({
    this.algo,
    this.value,
  });

  factory Hash.parse(XmlElement element) {
    return Hash(
      algo: element.getAttribute('algo'),
      value: element.innerText,
    );
  }
}
