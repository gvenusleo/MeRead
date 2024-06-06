import 'package:isar/isar.dart';
import 'package:meread/models/category.dart';
import 'package:meread/models/post.dart';

part 'feed.g.dart';

@collection
class Feed {
  Id? id = Isar.autoIncrement;
  String title;
  String url;
  String description;
  final category = IsarLink<Category>();
  bool fullText;
  int openType; // 0: App Read, 1: In-app tab, 2: System browser
  @Backlink(to: 'feed')
  final posts = IsarLinks<Post>();

  Feed({
    this.id,
    required this.title,
    required this.url,
    required this.description,
    required this.fullText,
    required this.openType,
  });
}
