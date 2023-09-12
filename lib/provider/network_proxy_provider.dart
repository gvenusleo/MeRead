import 'package:flutter/material.dart';
import 'package:meread/global/global.dart';

/// App 主题状态管理
class NetWorkProxyProvider extends ChangeNotifier {
  // 是否开启代理
  bool isProxy = prefs.getBool('isProxy') ?? false;
  // 代理地址
  String proxyAddress = prefs.getString('proxyAdress') ?? '';
  // 代理端口
  String proxyPort = prefs.getString('proxyPort') ?? '';

  Future<void> changeIsProxy(bool value) async {
    await prefs.setBool('isProxy', value);
    setState(() {
      isProxy = value;
    });
  }

  Future<void> changeProxyAddress(String value) async {
    await prefs.setString('proxyAdress', value);
    setState(() {
      proxyAddress = value;
    });
  }

  Future<void> changeProxyPort(String value) async {
    await prefs.setString('proxyPort', value);
    setState(() {
      proxyPort = value;
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
