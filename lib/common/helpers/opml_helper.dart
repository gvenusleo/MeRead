import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/common/global.dart';
import 'package:meread/common/helpers/feed_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:opml/opml.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OpmlHelper {
  // 导入 OPML 文件
  static Future<void> importOPML() async {
    logger.i('[opml]: 开始导入 OPML');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // file_picker 无法正确过滤 opml 格式文件
      // allowedExtensions: ['opml', 'xml'],
    );
    if (result != null) {
      if (result.files.first.extension != 'opml' &&
          result.files.first.extension != 'xml') {
        Get.snackbar(
          'error'.tr,
          'importErrorInfo'.tr,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
        );
        logger.i('[opml]: 导入错误，仅支持 OPML 或 XML 文件，'
            '当前文件扩展名为: ${result.files.first.extension}');
        return;
      } else {
        Get.dialog(
          AlertDialog(
            icon: const Icon(Icons.file_download_outlined),
            title: Text('startImport'.tr),
            content: const SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          barrierDismissible: false,
        );
        final List<int> count = await _parseOpml(result);
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Get.snackbar(
          'info'.tr,
          'importResultInfo'.trParams({
            'allCount': count[0].toString(),
            'successCount': count[1].toString(),
          }),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
        );
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        logger.i('[opml]: 导入结果，共发现 ${count[0]} 个订阅源，导入成功 ${count[1]} 个');
      }
    }
  }

  /// 导出 OPML 文件
  static Future<void> exportOPML() async {
    final Map<String, List<Feed>> feedMap = {}; // await Feed.groupByCategory();
    final head = OpmlHeadBuilder().title('Feeds From MeRead').build();
    final body = <OpmlOutline>[];
    for (var category in feedMap.keys) {
      var c = OpmlOutlineBuilder().title(category).text(category);
      for (var feed in feedMap[category]!) {
        c.addChild(OpmlOutlineBuilder()
            .title(feed.title)
            .text(feed.title)
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
    final String opmlString = opml.toXmlString(pretty: true);
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/feeds-from-MeRead.xml');
    await file.writeAsString(opmlString);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'exportOPML'.tr,
    ).then((value) {
      if (value.status == ShareResultStatus.success) {
        Get.snackbar(
          'info'.tr,
          'exportSuccess'.tr,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
        );
      }
    });
    await file.delete();
    logger.i('[opml]: 导出成功');
  }

  /// 解析 OPML 文件
  static Future<List<int>> _parseOpml(FilePickerResult result) async {
    final file = result.files.first;
    /* 读取文件内容，转为字符串 */
    final File opmlFile = File(file.path!);
    final String opmlString = await opmlFile.readAsString();
    int allCount = 0;
    int successCount = 0;
    final opml = OpmlDocument.parse(opmlString);
    await Future.wait(
      opml.body.map(
        (category) async {
          final String? categoryName = category.title ?? category.text;
          await Future.wait(
            category.children!.map(
              (opmlOutline) async {
                allCount++;
                if (await FeedHelper.isExists(opmlOutline.xmlUrl!) == null) {
                  Feed? feed = await FeedHelper.parse(
                    opmlOutline.xmlUrl!,
                    categoryName,
                    opmlOutline.title ?? opmlOutline.text,
                  );
                  if (feed != null) {
                    await FeedHelper.saveToIsar(feed);
                    successCount++;
                  }
                }
              },
            ),
          );
        },
      ),
    );
    return [allCount, successCount];
  }
}
