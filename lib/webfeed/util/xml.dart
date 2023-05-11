import 'dart:core';

import 'package:xml/xml.dart';

import '../util/iterable.dart';

Iterable<XmlElement>? findElements(
  XmlNode? node,
  String name, {
  bool recursive = false,
  String? namespace,
}) {
  try {
    if (recursive) {
      return node?.findAllElements(name, namespace: namespace);
    } else {
      return node?.findElements(name, namespace: namespace);
    }
  } on StateError {
    return null;
  }
}

bool parseBoolLiteral(XmlElement element, String tagName) {
  var v = element.findElements(tagName).firstOrNull?.text.toLowerCase().trim();
  if (v == null) return false;
  return ['yes', 'true'].contains(v);
}
