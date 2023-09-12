import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:meread/global/global.dart';

/// 初始化 Dio，设置代理
Dio initDio() {
  final dio = Dio();
  String proxyAddress = prefs.getString('proxyAdress') ?? '';
  String proxyPort = prefs.getString('proxyPort') ?? '';
  bool isProxy = prefs.getBool('isProxy') ?? false;
  if (isProxy && proxyAddress.isNotEmpty && proxyPort.isNotEmpty) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (uri) {
          return 'PROXY $proxyAddress:$proxyPort';
        };
        return client;
      },
    );
  }
  return dio;
}
