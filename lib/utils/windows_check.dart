import 'dart:io';

import 'package:webview_windows/webview_windows.dart';

/// 检查 Windows WebView 是否安装
Future<bool> isWebView2Runtime() async {
  if (Platform.isWindows) {
    return await WebviewController.getWebViewVersion() != null;
  }
  return true;
}
