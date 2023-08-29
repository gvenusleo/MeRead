import 'package:xml/xml.dart';

import '../../util/datetime.dart';
import '../../util/iterable.dart';

enum SyndicationUpdatePeriod { hourly, daily, weekly, monthly, yearly }

class Syndication {
  final SyndicationUpdatePeriod? updatePeriod;
  final int? updateFrequency;
  final DateTime? updateBase;

  Syndication({
    this.updatePeriod,
    this.updateFrequency,
    this.updateBase,
  });

  factory Syndication.parse(XmlElement element) {
    SyndicationUpdatePeriod updatePeriod;
    switch (element.findElements('sy:updatePeriod').firstOrNull?.innerText) {
      case 'hourly':
        updatePeriod = SyndicationUpdatePeriod.hourly;
        break;
      case 'daily':
        updatePeriod = SyndicationUpdatePeriod.daily;
        break;
      case 'weekly':
        updatePeriod = SyndicationUpdatePeriod.weekly;
        break;
      case 'monthly':
        updatePeriod = SyndicationUpdatePeriod.monthly;
        break;
      case 'yearly':
        updatePeriod = SyndicationUpdatePeriod.yearly;
        break;
      default:
        updatePeriod = SyndicationUpdatePeriod.daily;
        break;
    }
    return Syndication(
      updatePeriod: updatePeriod,
      updateFrequency: int.tryParse(
          element.findElements('sy:updateFrequency').firstOrNull?.innerText ??
              '1'),
      updateBase: parseDateTime(
          element.findElements('sy:updateBase').firstOrNull?.innerText),
    );
  }
}
