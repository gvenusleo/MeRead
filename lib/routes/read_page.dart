import 'package:dio/dio.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_main_element/html_main_element.dart';
import 'package:meread/models/post.dart';
import 'package:meread/provider/read_page_provider.dart';
import 'package:meread/utils/open_url_util.dart';
import 'package:meread/widgets/img_for_read.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  int _index = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.feedName),
        actions: [
          /* 在浏览器中打开 */
          IconButton(
            onPressed: () {
              openUrl(widget.post.link);
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
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.post.fullText &&
        !widget.post.fullTextCache &&
        widget.post.openType == 0) {
      setState(() {
        _index == 0;
      });
      initData();
    }
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
    String html = '''
<body>
<h1>${widget.post.title}</h1>
${widget.post.content}
</body>
''';
    return SelectionArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 24,
            horizontal: context.read<ReadPageProvider>().pagePadding.toDouble(),
          ),
          child: HtmlWidget(
            html,
            renderMode: RenderMode.column,
            factoryBuilder: () => _MyFactory(),
            textStyle: TextStyle(
              fontSize: context.read<ReadPageProvider>().fontSize.toDouble(),
              height: context.read<ReadPageProvider>().lineHeight,
            ),
            customStylesBuilder: (element) {
              return {
                'text-align': context.read<ReadPageProvider>().textAlign,
              };
            },
            customWidgetBuilder: (element) {
              if (element.localName == 'figure') {
                if (element.children.length == 1 &&
                    element.children[0].localName == 'img') {
                  String? imgUrl = element.children[0].attributes['src'];
                  if (imgUrl != null) {
                    return ImgForRead(
                      url: element.children[0].attributes['src']!,
                    );
                  }
                }
              }
              if (element.localName == 'img') {
                if (element.attributes['src'] != null) {
                  return ImgForRead(
                    url: element.attributes['src']!,
                  );
                }
              }
              return null;
            },
            onTapUrl: (String url) {
              try {
                openUrl(url);
                return true;
              } catch (e) {
                return false;
              }
            },
          ),
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
      _index = 1;
    });
    widget.post.updateToDb();
  }

  /* 根据 url 获取 html 内容 */
  Future<void> initData() async {
    await getFullText();
    setState(() {
      _index = 1;
    });
  }
}

/* 用于 iframe */
class _MyFactory extends WidgetFactory {
  @override
  bool get webView => true;
}
