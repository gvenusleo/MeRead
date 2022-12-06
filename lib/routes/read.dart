import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:meread/utils/parse.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/db.dart';
import '../models/models.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({
    super.key,
    required this.post,
    required this.initData,
    required this.fullText,
  });
  final Post post;
  final Map<String, dynamic> initData;
  final bool fullText;

  @override
  ReadPageState createState() => ReadPageState();
}

class ReadPageState extends State<ReadPage> {
  double appBarHeight = 56.0; // AppBar 高度
  int lastScrollY = 0; // 上次滚动位置

  Future<InAppWebView> getFullText() async {
    final String textColor = Theme.of(context) // 文本颜色
        .colorScheme
        .primary
        .value
        .toRadixString(16)
        .substring(2);
    final String backgroundColor = Theme.of(context) // 背景颜色
        .scaffoldBackgroundColor
        .value
        .toRadixString(16)
        .substring(2);
    final String cssStr = '''
/* CDN 服务仅供平台体验和调试使用，平台不承诺服务的稳定性，企业客户需下载字体包自行发布使用并做好备份。 */
@font-face {
  font-family: "思源宋体 CN VF Regular";
  src: url("//at.alicdn.com/wf/webfont/xRg1LrpJJqRG/T_MtMXsOAonqR5tTR7L4p.woff2") format("woff2"),
  url("//at.alicdn.com/wf/webfont/xRg1LrpJJqRG/MNkSp-5rictSiKrlMlU8q.woff") format("woff");
  font-display: swap;
}
body {
  font-family: "思源宋体 CN VF Regular", serif;
  font-size: ${widget.initData['fontSize']}px;
  line-height: ${widget.initData['lineheight']};
  color: #$textColor;
  background-color: #$backgroundColor;
  width: auto;
  height: auto;
  margin: 0;
  word-wrap: break-word;
  padding: 12px ${widget.initData['pagePadding']}px !important;
  text-align: ${widget.initData['textAlign']};
}
img {
  max-width: 100%;
  height: auto;
}
iframe {
  max-width: 100%;
  height: auto;
}
a {
  color: #$textColor;
  text-decoration: none;
  border-bottom: 1px solid #$textColor;
  padding-bottom: 1px;
  word-break: break-all;
}
blockquote {
  margin: 0;
  padding: 0 0 0 16px;
  border-left: 4px solid #9e9e9e;
}
h1 {
  font-size: 1.5em;
  font-weight: 700;
  margin: 0 0 0.5em 0;
}
''';
    const String loadingCss = '''
html {
  display: none;
}
''';
    final initCss = widget.fullText ? loadingCss : cssStr;
    late String bodyHtml;
    late String jsCode;

    if (widget.fullText) {
      // 强制使用 https
      widget.post.link =
          widget.post.link.replaceFirst(RegExp(r'^http://'), 'https://');
      // 去除链接末尾参数
      if (widget.post.link.contains('?')) {
        widget.post.link = widget.post.link
            .substring(0, widget.post.link.indexOf(RegExp(r'\?')));
      }
      bodyHtml = await crawlBody(widget.post.link);
      String jsTem = await rootBundle.loadString('assets/full_text.js');
      String addJs = '''
document.body.insertAdjacentHTML('afterbegin', `<h1>${widget.post.title}</h1>`);
document.head.insertAdjacentHTML('afterbegin', `<style>
$cssStr
</style>`);
''';
      jsCode = jsTem + addJs;
    } else {
      bodyHtml = widget.post.content;
      jsCode = '';
    }
    final String contentHtml = '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
$initCss
</style>
</head>
<body>
<h1>${widget.post.title}</h1>
$bodyHtml
</body>
<script type="module">
$jsCode
</script>
<style>
${widget.initData['customCss']}
</style>
</html>
''';
    return InAppWebView(
      initialData: widget.post.openType == 0 || widget.fullText
          ? InAppWebViewInitialData(data: contentHtml)
          : null,
      initialUrlRequest: widget.post.openType == 1
          ? URLRequest(url: Uri.parse(widget.post.link))
          : null,
      initialOptions: InAppWebViewGroupOptions(
        android: AndroidInAppWebViewOptions(
          useHybridComposition: false, // 关闭混合模式，提高性能，避免 WebView 闪烁
        ),
        crossPlatform: InAppWebViewOptions(
          transparentBackground: true,
        ),
      ),
      // 向下滑动时，隐藏 AppBar，向上滑动时，显示 AppBar
      onScrollChanged: (InAppWebViewController controller, int x, int y) {
        if (y > lastScrollY) {
          if (appBarHeight > 0) {
            double tem = appBarHeight - (y - lastScrollY).toDouble() / 10.0;
            setState(() {
              appBarHeight = tem >= 0 ? tem : 0;
            });
          }
        } else if (y < lastScrollY) {
          if (appBarHeight < 56) {
            double tem = appBarHeight + (lastScrollY - y).toDouble() / 10.0;
            setState(() {
              appBarHeight = tem <= 56 ? tem : 56;
            });
          }
        }
        lastScrollY = y;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text(
          widget.post.feedName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () async {
                    await markPostAsUnread(widget.post.id!);
                  },
                  child: Text(
                    '标记未读',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    await changePostFavorite(widget.post.id!);
                    setState(() {
                      widget.post.favorite = widget.post.favorite == 0 ? 1 : 0;
                    });
                  },
                  child: Text(
                    widget.post.favorite == 1 ? '取消收藏' : '收藏文章',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.post.link));
                  },
                  child: Text(
                    '复制链接',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Share.share(
                      widget.post.link,
                      subject: widget.post.title,
                    );
                  },
                  child: Text(
                    '分享文章',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getFullText(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return Center(
              child: Text(
                '正在获取全文……',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
        },
      ),
    );
  }
}
