import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

/// 使用 [InAppBrowser] 打开一个 url
void openUrl(String url) {
  try {
    InAppBrowser browser = InAppBrowser();
    browser.openUrlRequest(
      urlRequest: URLRequest(
        url: Uri.parse(url),
      ),
    );
  } catch (e) {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}
