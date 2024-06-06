import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/helpers/resolve_helper.dart';
import 'package:meread/models/category.dart';
import 'package:meread/models/feed.dart';
import 'package:opml/opml.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OpmlHelper {
  /// Import an OPML file
  static Future<void> importOpml() async {
    LogHelper.i('[opml]: Start import the opml file.');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // file_picker cannot filter opml format files correctly
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
        LogHelper.i(
            '[opml]: Import error, only OPML or XML files are supported. '
            'The current file extension is: ${result.files.first.extension}.');
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
        LogHelper.i(
            '[opml]: The import is completed. A total of ${count[0]} feeds were found and ${count[1]} were imported successfully.');
      }
    }
  }

  /// Export all Feeds as a Opml file
  static Future<void> exportOpml() async {
    final Map<String, List<Feed>> feedMap = {};
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
    LogHelper.i('[opml]: Export success.');
  }

  /// Parse Opml file
  static Future<List<int>> _parseOpml(FilePickerResult result) async {
    final file = result.files.first;
    final File opmlFile = File(file.path!);
    final String opmlString = await opmlFile.readAsString();
    int allCount = 0;
    int successCount = 0;
    final opml = OpmlDocument.parse(opmlString);
    await Future.wait(
      opml.body.map(
        (categoryOpml) async {
          final String? categoryName = categoryOpml.title ?? categoryOpml.text;
          final Category? category =
              await IsarHelper.getCategoryByName(categoryName!);
          await Future.wait(
            categoryOpml.children!.map(
              (opmlOutline) async {
                allCount++;
                if (await IsarHelper.isExistsFeed(opmlOutline.xmlUrl!) ==
                    null) {
                  Feed? feed = await ResolveHelper.parseFeed(
                    opmlOutline.xmlUrl!,
                    category,
                    opmlOutline.title ?? opmlOutline.text,
                  );
                  if (feed != null) {
                    IsarHelper.saveFeed(feed);
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
