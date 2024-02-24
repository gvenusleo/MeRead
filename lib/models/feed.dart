import 'package:isar/isar.dart';

part 'feed.g.dart';

/// 定义 Feed 类
@collection
class Feed {
  Id? id = Isar.autoIncrement;
  String title; // 订阅源名称
  String url; // 订阅源地址
  String description; // 订阅源描述
  String category; // 订阅源分类
  bool fullText; // 是否全文
  int openType; // 打开方式：0-阅读器 1-内置标签页 2-系统浏览器

  Feed({
    this.id,
    required this.title,
    required this.url,
    required this.description,
    required this.category,
    required this.fullText,
    required this.openType,
  });
}
