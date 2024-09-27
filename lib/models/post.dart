import 'package:isar/isar.dart';
import 'package:meread/models/feed.dart';

part 'post.g.dart';

/// 定义 Post 类
@collection
class Post {
  Id? id = Isar.autoIncrement;
  String title; // 标题
  String link; // 链接
  String content; // 内容
  DateTime pubDate; // 发布时间
  bool read; // 是否已读
  bool favorite; // 是否已收藏
  bool fullText; // 是否已经有全文
  DateTime createdAt; // 创建时间
  final feed = IsarLink<Feed>();

  Post({
    this.id,
    required this.title,
    required this.link,
    required this.content,
    required this.pubDate,
    required this.read,
    required this.favorite,
    required this.fullText,
    required this.createdAt,
  });
}
