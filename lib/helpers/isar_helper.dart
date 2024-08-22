import 'dart:io';

import 'package:isar/isar.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:path_provider/path_provider.dart';

class IsartHelper {
  static late Isar _isar;

  static Future<void> init()async {
    final Directory dir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();
    _isar = await Isar.open(
    [FeedSchema, PostSchema],
    directory: dir.path,
    );
    LogHelper.i('[Isar]: Open isar database: ${dir.path}');
  }
}