// 定义 Feed 类
class Feed {
  int? id;
  String name; // 订阅源名称
  String url; // 订阅源地址
  String description; // 订阅源描述
  String category; // 订阅源分类
  int fullText; // 是否全文：0否 1是
  int openType; // 打开方式：0阅读器 1内置标签页 2系统浏览器
  Feed({
    this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.category,
    required this.fullText,
    required this.openType,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'description': description,
      'category': category,
      'fullText': fullText,
      'openType': openType,
    };
  }
}

// 定义 Post 类
class Post {
  int? id;
  int feedId; // 订阅源 ID
  String title; // 标题
  String feedName; // 订阅源名称
  String link; // 链接
  String content; // 内容
  String pubDate; // 发布时间
  int read; // 是否已读：0否 1是
  int favorite; // 是否已收藏：0否 1是
  int openType; // 打开方式：0阅读器 1内置标签页 2系统浏览器
  Post({
    this.id,
    required this.feedId,
    required this.title,
    required this.feedName,
    required this.link,
    required this.content,
    required this.pubDate,
    required this.read,
    required this.favorite,
    required this.openType,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'feedId': feedId,
      'title': title,
      'feedName': feedName,
      'link': link,
      'content': content,
      'pubDate': pubDate,
      'read': read,
      'favorite': favorite,
      'openType': openType,
    };
  }
}
