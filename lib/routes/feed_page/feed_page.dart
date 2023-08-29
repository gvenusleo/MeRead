import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:meread/routes/feed_page/edit_feed_page.dart';
import 'package:meread/routes/read.dart';
import 'package:meread/utils/dir.dart';
import 'package:meread/utils/parse.dart';
import 'package:meread/widgets/post_container.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.feed});
  final Feed feed;
  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  List<Post> postList = [];
  bool onlyUnread = false;
  bool onlyFavorite = false;
  String? fontDir;

  Future<void> getPostList() async {
    await widget.feed.getAllPosts().then(
          (value) => setState(
            () {
              postList = value;
            },
          ),
        );
  }

  Future<void> getUnreadPostList() async {
    widget.feed.getUnreadPosts().then(
          (value) => setState(
            () {
              postList = value;
            },
          ),
        );
  }

  Future<void> getFavoritePostList() async {
    await widget.feed.getAllfavoritePosts().then(
          (value) => setState(
            () {
              postList = value;
            },
          ),
        );
  }

  void initFontDir() {
    getFontDir().then((value) {
      setState(() {
        fontDir = value;
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
                // 删除订阅源
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
            bool parseFeed = await parseFeedContent(widget.feed);
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
            cacheExtent: 30, // 预加载
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
                          fullText: widget.feed.fullText == 1,
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
                  // 标记文章为已读
                  if (postList[index].read == 0) {
                    postList[index].markRead();
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
