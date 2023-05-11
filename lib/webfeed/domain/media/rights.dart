import 'package:xml/xml.dart';

class Rights {
  final String? status;

  Rights({
    this.status,
  });

  factory Rights.parse(XmlElement element) {
    return Rights(
      status: element.getAttribute('status'),
    );
  }
}
