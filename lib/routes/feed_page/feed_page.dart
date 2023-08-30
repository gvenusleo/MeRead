import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:meread/routes/feed_page/edit_feed_page.dart';
import 'package:meread/routes/read.dart';
import 'package:meread/utils/font_util.dart';
import 'package:meread/utils/parse_post_util.dart';
import 'package:meread/widgets/post_container.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.feed});
  final Feed feed;
  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  // 文章列表
  List<Post> postList = [];
  // 是否只显示未读文章
  bool onlyUnread = false;
  // 是否只显示收藏文章
  bool onlyFavorite = false;
  // 字体目录
  String? fontDir;

  /* 获取文章列表 */
  Future<void> getPostList() async {
    await widget.feed.getAllPosts().then(
          (value) => setState(
            () {
              postList = value;
            },
          ),
        );
  }

  /* 获取未读文章列表 */
  Future<void> getUnreadPostList() async {
    widget.feed.getUnreadPosts().then(
          (value) => setState(
            () {
              postList = value;
            },
          ),
        );
  }

  /* 获取收藏文章列表 */
  Future<void> getFavoritePostList() async {
    await widget.feed.getFavoritePosts().then(
          (value) => setState(
            () {
              postList = value;
            },
          ),
        );
  }

  /* 获取字体目录 */
  void initFontDir() {
    getFontDir().then((value) {
      setState(() {
        fontDir = value.path;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPostList();
    initFontDir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed.name),
        actions: [
          /* 未读筛选 */
          IconButton(
            onPressed: () async {
              if (onlyUnread) {
                await getPostList();
                setState(() {
                  onlyUnread = false;
                });
              } else {
                await getUnreadPostList();
                setState(() {
                  onlyUnread = true;
                  onlyFavorite = false;
                });
              }
            },
            icon: onlyUnread
                ? const Icon(Icons.radio_button_checked)
                : const Icon(Icons.radio_button_unchecked),
          ),
          /* 收藏筛选 */
          IconButton(
            onPressed: () async {
              if (onlyFavorite) {
                await getPostList();
                setState(() {
                  onlyFavorite = false;
                });
              } else {
                await getFavoritePostList();
                setState(() {
                  onlyFavorite = true;
                  onlyUnread = false;
                });
              }
            },
            icon: onlyFavorite
                ? const Icon(Icons.bookmark)
                : const Icon(Icons.bookmark_border_outlined),
          ),
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                /* 全标已读 */
                PopupMenuItem(
                  onTap: () async {
                    await widget.feed.markPostsAsRead();
                    if (onlyUnread) {
                      getUnreadPostList();
                    } else if (onlyFavorite) {
                      getFavoritePostList();
                    } else {
                      getPostList();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.markAllAsRead),
                ),
                /* 编辑订阅源 */
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => EditFeedPage(feed: widget.feed),
                        ),
                      ).then((value) {
                        if (onlyUnread) {
                          getUnreadPostList();
                        } else if (onlyFavorite) {
                          getFavoritePostList();
                        } else {
                          getPostList();
                        }
                      });
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.editFeed),
                ),
                const PopupMenuDivider(),
                /* 删除订阅源 */
                PopupMenuItem(
                  onTap: () async {
                    await Future.delayed(const Duration(seconds: 0));
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.deleteFeed),
                          content: Text(
                            AppLocalizations.of(context)!
                                .doYouWantToDeleteThisFeed,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () async {
                                await widget.feed.deleteFromDb();
                                if (!mounted) return;
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.ok),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.deleteFeed),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            /* 刷新订阅源 */
            bool parseFeed = await parsePosts(widget.feed);
            if (onlyUnread) {
              getUnreadPostList();
            } else if (onlyFavorite) {
              getFavoritePostList();
            } else {
              getPostList();
            }
            if (!mounted) return;
            Fluttertoast.showToast(
              msg: parseFeed
                  ? AppLocalizations.of(context)!.updateSuccess
                  : AppLocalizations.of(context)!.updateFailed,
            );
          },
          child: ListView.separated(
            itemCount: postList.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  if (postList[index].openType == 2) {
                    await launchUrl(
                      Uri.parse(postList[index].link),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    if (fontDir == null) return;
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ReadPage(
                          post: postList[index],
                          fontDir: fontDir!,
                        ),
                      ),
                    ).then((value) {
                      if (onlyUnread) {
                        getUnreadPostList();
                      } else if (onlyFavorite) {
                        getFavoritePostList();
                      } else {
                        getPostList();
                      }
                    });
                  }
                },
                child: PostContainer(post: postList[index]),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 4);
            },
          ),
        ),
      ),
    );
  }
}
