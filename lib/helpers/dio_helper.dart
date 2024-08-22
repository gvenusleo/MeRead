import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/helpers/prefs_helper.dart';

class DioHelper {
  static late Dio _dio;

  static void init() {
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
      LogHelper.i('[dio]: Init Dio with proxy: $proxyAddress:$proxyPort');
    } else {
      LogHelper.i('[dio]: Init Dio without proxy');
    }
  }

  static Future<Response> get(String url) async {
    return await _dio.get(url);
  }
}
