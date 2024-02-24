import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:meread/common/global.dart';
import 'package:meread/common/helpers/prefs_helper.dart';

class DioHelper {
  late Dio _dio;

  Dio get dio => _dio;

  DioHelper() {
    _dio = Dio();
    String proxyAddress = PrefsHelper.proxyAddress;
    String proxyPort = PrefsHelper.proxyPort;
    bool isProxy = PrefsHelper.useProxy;
    if (isProxy && proxyAddress.isNotEmpty && proxyPort.isNotEmpty) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (uri) {
            return 'PROXY $proxyAddress:$proxyPort';
          };
          return client;
        },
      );
      logger.i('[dio]: 初始化 Dio 完成, 使用代理: $proxyAddress:$proxyPort');
    } else {
      logger.i('[dio]: 初始化 Dio 完成, 未使用代理');
    }
  }
}
