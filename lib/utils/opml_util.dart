import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/utils/parse_feed_util.dart';
import 'package:opml/opml.dart';

/// 解析 OPML 文件
/// 返回 [Feed] 解析失败的数量
Future<int> parseOpml(FilePickerResult result) async {
  final file = result.files.first;
  /* 读取文件内容，转为字符串 */
  final File opmlFile = File(file.path!);
  final String opmlString = await opmlFile.readAsString();
  int failCount = 0;
  final opml = OpmlDocument.parse(opmlString);
  await Future.wait(
    opml.body.map(
      (category) async {
        final String? categoryName = category.title;
        await Future.wait(
          category.children!.map(
            (opmlOutline) async {
              if (!await Feed.isExist(opmlOutline.xmlUrl!)) {
                Feed? feed = await parseFeed(
                    opmlOutline.xmlUrl!, categoryName, opmlOutline.title!);
                if (feed != null) {
                  await feed.insertOrUpdateToDb();
                } else {
                  failCount++;
                }
              }
            },
          ),
        );
      },
    ),
  );
  return failCount;
}

/// 导出 OPML 文件
Future<String> exportOpmlBase() async {
  final Map<String, List<Feed>> feedMap = await Feed.groupByCategory();
  final head = OpmlHeadBuilder().title('Feeds From MeRead').build();
  final body = <OpmlOutline>[];
  for (var category in feedMap.keys) {
    var c = OpmlOutlineBuilder().title(category).text(category);
    for (var feed in feedMap[category]!) {
      c.addChild(OpmlOutlineBuilder()
          .title(feed.name)
          .text(feed.name)
          .type('rss')
          .xmlUrl(feed.url)
          .build());
    }
    body.add(c.build());
  }
  final opml = OpmlDocument(
    head: head,
    body: body,
  );
  return opml.toXmlString(pretty: true);
}
