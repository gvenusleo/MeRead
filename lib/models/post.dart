import 'package:isar/isar.dart';
import 'package:meread/models/feed.dart';

part 'post.g.dart';

@collection
class Post {
  Id? id = Isar.autoIncrement;
  final feed = IsarLink<Feed>();
  String title;
  String link;
  String content;
  DateTime pubDate;
  bool read;
  bool favorite;
  bool fullText;

  Post({
    this.id,
    required this.title,
    required this.link,
    required this.content,
    required this.pubDate,
    required this.read,
    required this.favorite,
    required this.fullText,
  });
}
