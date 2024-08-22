import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/feed_helper.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:opml/opml.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OpmlHelper {
  static Future<void> importOPML() async {
    LogHelper.i('[opml]: Start import OPML');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // file_picker not filtering opml files correctly
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
        LogHelper.i('[opml]: Import failed, '
            'file format error: ${result.files.first.extension}');
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
        LogHelper.i('[opml]: Import completed, '
            'total: ${count[0]}, success: ${count[1]}');
      }
    }
  }

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
    LogHelper.i('[opml]: Export completed');
  }

  static Future<List<int>> _parseOpml(FilePickerResult result) async {
    final file = result.files.first;
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
                if (IsarHelper.getFeedByUrl(opmlOutline.xmlUrl!) == null) {
                  Feed? feed = await FeedHelper.parse(
                    opmlOutline.xmlUrl!,
                    categoryName,
                    opmlOutline.title ?? opmlOutline.text,
                  );
                  if (feed != null) {
                    IsarHelper.putFeed(feed);
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
