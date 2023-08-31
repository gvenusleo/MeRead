import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_main_element/html_main_element.dart';
import 'package:meread/models/post.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:meread/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({
    super.key,
    required this.post,
    required this.fontDir,
  });
  final Post post;
  final String fontDir;

  @override
  ReadPageState createState() => ReadPageState();
}

class ReadPageState extends State<ReadPage> {
  // 堆叠索引
  int _index = 0;
  // 内容 html
  String contentHtml = '';

  late InAppWebViewController webViewController;
  GlobalKey<ScaffoldState> webViewKey = GlobalKey<ScaffoldState>();

  /* 根据 url 获取 html 内容 */
  Future<void> initData(String url) async {
    if (widget.post.fullText &&
        !widget.post.fullTextCache &&
        widget.post.openType == 0) {
      setState(() {
        _index = 0;
      });
      /* 获取全文 */
      final response = await Dio().get(url);
      final document = html_parser.parse(response.data);
      final bestElemReadability =
          readabilityMainElement(document.documentElement!);
      widget.post.content = bestElemReadability.outerHtml;
      setState(() {
        contentHtml = widget.post.content;
        _index = 1;
      });
      widget.post.updateToDb();
    } else {
      setState(() {
        contentHtml = widget.post.content;
        _index = 1;
      });
    }
    /* 更新文章信息 */
    if (!widget.post.read) {
      widget.post.read = true;
      widget.post.fullTextCache = true;
      widget.post.updateToDb();
    }
  }

  @override
  void initState() {
    super.initState();
    initData(widget.post.link);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final String textColor = themeData.textTheme.bodyLarge!.color!.value
        .toRadixString(16)
        .substring(2);
    final String backgroundColor =
        themeData.scaffoldBackgroundColor.value.toRadixString(16).substring(2);
    final titleStr = '<h1>${widget.post.title}</h1>';
    final String cssStr = '''
@font-face {
  font-family: 'customFont';
  src: url('${widget.fontDir}/${context.watch<ThemeProvider>().themeFont}');
}
body {
  font-family: 'customFont';
  font-size: ${context.watch<ReadPageProvider>().fontSize}px;
  line-height: ${context.watch<ReadPageProvider>().lineHeight};
  color: #$textColor;
  background-color: #$backgroundColor;
  width: auto;
  height: auto;
  margin: 0;
  word-wrap: break-word;
  padding: 12px ${context.watch<ReadPageProvider>().pagePadding}px !important;
  text-align: ${context.watch<ReadPageProvider>().textAlign};
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
img,figure,video,iframe {
  max-width: 100% !important;
  height: auto;
  margin: 0 auto;
  display: block;
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
  width: 100% !important;
  table-layout: fixed;
}
table td {
  padding: 0 8px;
}

table, th, td {
  border: 1px solid #$textColor;
  border-collapse: collapse;
}
${context.watch<ReadPageProvider>().customCss}
''';
    return WillPopScope(
      onWillPop: () async {
        if (await webViewController.canGoBack()) {
          await webViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: webViewKey,
        appBar: AppBar(
          title: Text(widget.post.feedName),
          actions: [
            /* 在外部浏览器中打开 */
            IconButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(widget.post.link),
                  mode: LaunchMode.externalApplication,
                );
              },
              icon: const Icon(Icons.open_in_browser_outlined),
            ),
            /* 分享 */
            IconButton(
              onPressed: () {
                Share.share(
                  widget.post.link,
                  subject: widget.post.title,
                );
              },
              icon: const Icon(Icons.share_outlined),
            ),
            PopupMenuButton(
              position: PopupMenuPosition.under,
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  /* 标记为未读 */
                  PopupMenuItem(
                    onTap: () async {
                      await widget.post.markAsUnread();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.visibility_off_outlined, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.markAsUnread,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  /* 更改收藏状态 */
                  PopupMenuItem(
                    onTap: () async {
                      await widget.post.changeFavorite();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bookmark_border_outlined, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          widget.post.favorite
                              ? AppLocalizations.of(context)!.cancelCollect
                              : AppLocalizations.of(context)!.collectPost,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  /* 复制链接 */
                  PopupMenuItem(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.post.link));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link_outlined, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.copyLink,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: _buildBody(cssStr, titleStr),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(String cssStr, String titleStr) {
    if (_index == 0) {
      return Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
              ),
              const SizedBox(height: 12),
              Text(AppLocalizations.of(context)!.gettingFullText),
            ],
          ),
        ),
      );
    }
    return InAppWebView(
      initialData: widget.post.openType == 0
          ? InAppWebViewInitialData(
              data: '''
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
$contentHtml
</body>
</html>
''',
              baseUrl: Uri.directory(widget.fontDir),
            )
          : null,
      initialUrlRequest: widget.post.openType != 0
          ? URLRequest(
              url: Uri.parse(
                widget.post.link.replaceFirst(RegExp(r'^http://'), 'https://'),
              ),
            )
          : null,
      initialOptions: InAppWebViewGroupOptions(
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        crossPlatform: InAppWebViewOptions(
          transparentBackground: true,
        ),
      ),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
    );
  }
}
