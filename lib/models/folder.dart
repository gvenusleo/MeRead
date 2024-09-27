import 'package:isar/isar.dart';
import 'package:meread/models/feed.dart';

part 'folder.g.dart';

@collection
class Folder {
  Id id = Isar.autoIncrement;
  String name;
  @Backlink(to: 'folder')
  final feeds = IsarLinks<Feed>();
  DateTime createdAt;
  DateTime updatedAt;

  Folder({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}
