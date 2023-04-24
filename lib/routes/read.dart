import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';

import '../data/db.dart';
import '../models/post.dart';

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
  int _index = 1; // 堆叠索引

  @override
  void initState() {
    super.initState();
    if (widget.fullText && widget.post.read != 2 && widget.post.openType == 0) {
      setState(() {
        _index = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String textColor = Theme.of(context)
        .textTheme
        .bodyLarge!
        .color!
        .value
        .toRadixString(16)
        .substring(2);
    final String backgroundColor = Theme.of(context)
        .scaffoldBackgroundColor
        .value
        .toRadixString(16)
        .substring(2);
    final titleStr =
        widget.post.read == 2 ? '' : '<h1>${widget.post.title}</h1>';
    final String cssStr = '''
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
h1 {
  font-size: 1.5em;
  font-weight: 700;
}
h2 {
  font-size: 1.25em;
  font-weight: 700;
}
h3,h4,h5,h6 {
  font-size: 1.0em;
  font-weight: 700;
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
pre {
  white-space: pre-wrap;
  word-break: break-all;
}
table {
  width: 100%;
  table-layout: fixed;
}
table td {
  padding: 0 8px;
}

table, th, td {
  border: 1px solid #$textColor;
  border-collapse: collapse;
}

${widget.initData['customCss']}
''';
    final String contentHtml = '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
$cssStr
</style>
</head>
<body>
$titleStr
${widget.post.content}
</body>
</html>
''';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text(widget.post.feedName),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
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
      body: IndexedStack(
        index: _index,
        children: [
          Center(
            child: Text(
              "正在获取全文……",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          InAppWebView(
            initialData: !(widget.post.openType == 1 ||
                    (widget.fullText &&
                        widget.post.openType == 0 &&
                        widget.post.read != 2))
                ? InAppWebViewInitialData(data: contentHtml)
                : null,
            initialUrlRequest: widget.post.openType == 1 ||
                    (widget.fullText &&
                        widget.post.openType == 0 &&
                        widget.post.read != 2)
                ? URLRequest(
                    url: Uri.parse(
                      widget.post.link
                          .replaceFirst(RegExp(r'^http://'), 'https://'),
                    ),
                  )
                : null,
            initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
                useHybridComposition: false, // 关闭混合模式，提高性能，避免 WebView 闪烁
              ),
              crossPlatform: InAppWebViewOptions(
                transparentBackground: true,
              ),
            ),
            onLoadStop: (controller, url) async {
              if (widget.fullText &&
                  widget.post.openType == 0 &&
                  widget.post.read != 2) {
                await controller.injectJavascriptFileFromAsset(
                    assetFilePath: 'assets/full_text.js');
                await controller.injectCSSCode(source: cssStr);
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    _index = 1;
                  });
                });
                final String? newContent = await controller.getHtml();
                if (newContent != null) {
                  // 删除 newContent 中 style 标签和 script 标签
                  final String newContentWithoutScriptAndStyle = newContent
                      .replaceAll(RegExp(r'<script>[\s\S]*?</script>'), '')
                      .replaceAll(RegExp(r'<style>[\s\S]*?</style>'), '');
                  widget.post.content = newContentWithoutScriptAndStyle;
                  widget.post.read = 2;
                  updatePost(widget.post);
                }
              }
            },
            // 向下滑动时，隐藏 AppBar，向上滑动时，显示 AppBar
            onScrollChanged: (InAppWebViewController controller, int x, int y) {
              if (y > lastScrollY) {
                if (appBarHeight > 0) {
                  double tem =
                      appBarHeight - (y - lastScrollY).toDouble() / 10.0;
                  setState(() {
                    appBarHeight = tem >= 0 ? tem : 0;
                  });
                }
              } else if (y < lastScrollY) {
                if (appBarHeight < 56) {
                  double tem =
                      appBarHeight + (lastScrollY - y).toDouble() / 10.0;
                  setState(() {
                    appBarHeight = tem <= 56 ? tem : 56;
                  });
                }
              }
              lastScrollY = y;
            },
          )
        ],
      ),
    );
  }
}
