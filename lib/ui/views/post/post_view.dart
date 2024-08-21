import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:meread/common/helpers/prefs_helper.dart';
import 'package:meread/models/post.dart';
import 'package:meread/ui/viewmodels/post/post_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    final Post p = Get.arguments;
    final c = Get.put(PostController(p));
    return Scaffold(
      appBar: AppBar(
        title: Text(c.post.value.feed.value?.title ?? ''),
        actions: [
          /* 在浏览器中打开 */
          IconButton(
            onPressed: c.openInBrowser,
            icon: const Icon(Icons.open_in_browser_outlined),
          ),
          /* 获取全文 */
          IconButton(
            onPressed: c.getFullText,
            icon: const Icon(Icons.article_outlined),
          ),
          PopupMenuButton(
            elevation: 1,
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                /* 标记为未读 */
                PopupMenuItem(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: c.markAsUnread,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.visibility_off_outlined, size: 20),
                      const SizedBox(width: 10),
                      Text('markAsUnread'.tr),
                    ],
                  ),
                ),
                /* 更改收藏状态 */
                PopupMenuItem(
                  onTap: c.changeFavorite,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bookmark_border_outlined, size: 20),
                      const SizedBox(width: 10),
                      Obx(() => Text(
                            c.post.value.favorite
                                ? 'cancelFavorite'.tr
                                : 'markAsFavorite'.tr,
                          )),
                    ],
                  ),
                ),
                const PopupMenuDivider(height: 0),
                /* 复制链接 */
                PopupMenuItem(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: c.post.value.link));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.link_outlined, size: 20),
                      const SizedBox(width: 10),
                      Text('copyLink'.tr),
                    ],
                  ),
                ),
                /* 分享 */
                PopupMenuItem(
                  onTap: () {
                    Share.share(
                      '${c.post.value.title}\n${c.post.value.link}',
                      subject: c.post.value.title,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.share_outlined, size: 20),
                      const SizedBox(width: 10),
                      Text('sharePost'.tr),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SelectionArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: 18,
              horizontal: PrefsHelper.readPagePadding.toDouble(),
            ),
            child: Obx(
              () => c.fullTexting.value
                  ? Center(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 12),
                            Text('fullTextLoading'.tr),
                          ],
                        ),
                      ),
                    )
                  : HtmlWidget(
                      '<h1>${c.post.value.title}</h1>${c.post.value.content}',
                      textStyle: TextStyle(
                        fontSize: PrefsHelper.readFontSize.toDouble(),
                        height: PrefsHelper.readLineHeight,
                      ),
                      onTapUrl: (url) {
                        launchUrlString(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                        return true;
                      },
                      onLoadingBuilder: (context, element, progress) {
                        return Center(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 12),
                                Text('loading'.tr),
                              ],
                            ),
                          ),
                        );
                      },
                      customStylesBuilder: (element) {
                        if (element.localName == 'h1') {
                          return {
                            'font-size': '1.8em',
                            'line-height': '1.3em',
                            'text-align': PrefsHelper.readTextAlign,
                          };
                        }
                        return {
                          'text-align': PrefsHelper.readTextAlign,
                        };
                      },
                      customWidgetBuilder: (element) {
                        if (element.localName == 'figure') {
                          if (element.children.length == 1 &&
                              element.children[0].localName == 'img') {
                            String? imgUrl =
                                element.children[0].attributes['src'];
                            if (imgUrl != null) {
                              return ImgForRead(
                                url: element.children[0].attributes['src']!,
                              );
                            }
                          }
                          if (element.children.length == 2 &&
                              element.children[0].localName == 'img' &&
                              element.children[1].localName == 'figcaption') {
                            String? imgUrl =
                                element.children[0].attributes['src'];
                            if (imgUrl != null) {
                              return Column(
                                children: [
                                  ImgForRead(
                                    url: element.children[0].attributes['src']!,
                                  ),
                                  Text(
                                    element.children[1].text,
                                    style: TextStyle(
                                      fontSize: PrefsHelper.readFontSize - 4,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      height: PrefsHelper.readLineHeight,
                                    ),
                                  ),
                                ],
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
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 用于阅读页面的图片组件
class ImgForRead extends StatelessWidget {
  const ImgForRead({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const SizedBox.shrink();
    }
    return Image.network(
      url!,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withAlpha(80),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 3,
                ),
                const SizedBox(height: 8),
                Text('imageLoading'.tr),
              ],
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withAlpha(80),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image_outlined),
                const SizedBox(height: 8),
                Text('imageLoadError'.tr),
              ],
            ),
          ),
        );
      },
    );
  }
}
