import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_main_element/html_main_element.dart';
import 'package:meread/models/post.dart';
import 'package:meread/provider/read_page_provider.dart';
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

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    final titleStr = '<h1>${widget.post.title}</h1>';

    return Scaffold(
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
          /* 获取全文 */
          IconButton(
            onPressed: getFullText,
            icon: const Icon(Icons.article_outlined),
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
                      ),
                    ],
                  ),
                ),
                /* 分享 */
                PopupMenuItem(
                  onTap: () {
                    Share.share(
                      widget.post.link,
                      subject: widget.post.title,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.share_outlined, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.sharePost,
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
          child: _buildBody(titleStr),
        ),
      ),
    );
  }

  Widget _buildBody(String titleStr) {
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
    String html = '''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
${context.watch<ReadPageProvider>().customCss}
</style>
</head>
<body>
$titleStr
$contentHtml
</body>
''';
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.watch<ReadPageProvider>().pagePadding.toDouble(),
      ),
      child: SelectionArea(
        child: Html(
          data: html,
          style: {
            'body': Style(
              fontSize: FontSize(
                context.watch<ReadPageProvider>().fontSize.toDouble(),
              ),
              lineHeight: LineHeight(
                context.watch<ReadPageProvider>().lineHeight,
              ),
              textAlign: {
                    'left': TextAlign.left,
                    'right': TextAlign.right,
                    'center': TextAlign.center,
                    'justify': TextAlign.justify,
                  }[context.watch<ReadPageProvider>().textAlign] ??
                  TextAlign.justify,
            ),
            'h1': Style(
              fontSize: FontSize(
                context.watch<ReadPageProvider>().fontSize.toDouble() * 1.5,
              ),
            ),
            'h2': Style(
              fontSize: FontSize(
                context.watch<ReadPageProvider>().fontSize.toDouble() * 1.3,
              ),
            ),
            'h3': Style(
              fontSize: FontSize(
                context.watch<ReadPageProvider>().fontSize.toDouble() * 1.1,
              ),
            ),
            'h4': Style(
              fontSize: FontSize(
                context.watch<ReadPageProvider>().fontSize.toDouble(),
              ),
            ),
            'h5': Style(
              fontSize: FontSize(
                context.watch<ReadPageProvider>().fontSize.toDouble(),
              ),
            ),
            'h6': Style(
              fontSize: FontSize(
                context.watch<ReadPageProvider>().fontSize.toDouble(),
              ),
            ),
          },
          onLinkTap: (url, attributes, element) {
            if (url != null) {
              launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            }
          },
          extensions: [
            OnImageTapExtension(
              onImageTap: (url, attributes, element) {
                print(url);
                print(attributes.toString());
                print(element.toString());
              },
            ),
          ],
        ),
      ),
    );
  }

  /* 获取全文 */
  Future<void> getFullText() async {
    setState(() {
      _index = 0;
    });
    /* 获取全文 */
    final response = await Dio().get(widget.post.link);
    final document = html_parser.parse(response.data);
    final bestElemReadability =
        readabilityMainElement(document.documentElement!);
    widget.post.content = bestElemReadability.outerHtml;
    widget.post.fullTextCache = true;
    setState(() {
      contentHtml = widget.post.content;
      _index = 1;
    });
    widget.post.updateToDb();
  }

  /* 根据 url 获取 html 内容 */
  Future<void> initData() async {
    if (widget.post.fullText &&
        !widget.post.fullTextCache &&
        widget.post.openType == 0) {
      setState(() {
        _index = 0;
      });
      /* 获取全文 */
      final response = await Dio().get(widget.post.link);
      final document = html_parser.parse(response.data);
      final bestElemReadability =
          readabilityMainElement(document.documentElement!);
      widget.post.content = bestElemReadability.outerHtml;
      setState(() {
        contentHtml = widget.post.content;
        _index = 1;
      });
      widget.post.fullTextCache = true;
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
      widget.post.updateToDb();
    }
  }
}
