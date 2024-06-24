import 'package:isar/isar.dart';
import 'package:meread/models/feed.dart';

part 'category.g.dart';

@collection
class Category {
  Id? id = Isar.autoIncrement;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  @Backlink(to: 'category')
  final feeds = IsarLinks<Feed>();

  Category({
    this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}
