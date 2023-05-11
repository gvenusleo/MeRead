import 'package:intl/intl.dart';

const rfc822DatePattern = 'EEE, dd MMM yyyy HH:mm:ss Z';

DateTime? parseDateTime(dateString) {
  if (dateString == null) return null;
  return _parseRfc822DateTime(dateString) ?? _parseIso8601DateTime(dateString);
}

DateTime? _parseRfc822DateTime(String dateString) {
  try {
    final num length = dateString.length.clamp(0, rfc822DatePattern.length);
    final trimmedPattern = rfc822DatePattern.substring(
        0,
        length
            as int?); //Some feeds use a shortened RFC 822 date, e.g. 'Tue, 04 Aug 2020'
    final format = DateFormat(trimmedPattern, 'en_US');
    return format.parse(dateString);
  } on FormatException {
    return null;
  }
}

DateTime? _parseIso8601DateTime(dateString) {
  try {
    return DateTime.parse(dateString);
  } on FormatException {
    return null;
  }
}
