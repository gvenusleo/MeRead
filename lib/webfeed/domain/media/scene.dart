import 'package:xml/xml.dart';

import '../../util/iterable.dart';

class Scene {
  final String? title;
  final String? description;
  final String? startTime;
  final String? endTime;

  Scene({
    this.title,
    this.description,
    this.startTime,
    this.endTime,
  });

  factory Scene.parse(XmlElement element) {
    return Scene(
      title: element.findElements('sceneTitle').firstOrNull?.text,
      description: element.findElements('sceneDescription').firstOrNull?.text,
      startTime: element.findElements('sceneStartTime').firstOrNull?.text,
      endTime: element.findElements('sceneEndTime').firstOrNull?.text,
    );
  }
}
