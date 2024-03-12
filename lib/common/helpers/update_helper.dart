import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/common/global.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateHelper {
  /// 检查更新
  static Future<void> checkUpdate() async {
    logger.i('[update]: 开始检查更新');
    Get.snackbar(
      'info'.tr,
      'checkingForUpdates'.tr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
    try {
      /* 通过访问 https://github.com/gvenusleo/MeRead/releases/latest 获取最新版本号 */
      final Dio dio = appDio.dio;
      final response = await dio.get(
        'https://github.com/gvenusleo/MeRead/releases/latest',
      );
      /* 获取网页 title */
      final String title =
          response.data.split('<title>')[1].split('</title>')[0];
      final String latestVersion = title.split(' ')[1];
      if (latestVersion == applicationVersion) {
        Get.closeAllSnackbars();
        Get.snackbar(
          'info'.tr,
          'alreadyLatestVersion'.tr,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
        );
        logger.i('[update]: 已经是最新版本 v$applicationVersion');
      } else {
        Get.closeAllSnackbars();
        Get.dialog(
          AlertDialog(
            icon: const Icon(Icons.update_outlined),
            title: Text('newVersionAvailable'.tr),
            content: Text('downloadInfo'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                        'https://github.com/gvenusleo/MeRead/releases/latest'),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Text('downloadNow'.tr),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('temporarilyCancel'.tr),
              ),
            ],
          ),
        );
        logger.i('[update]: 发现新版本 v$latestVersion ，当前版本 v$applicationVersion');
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'checkUpdateError'.tr);
    }
  }
}
