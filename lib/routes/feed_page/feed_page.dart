import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/feed.dart';
import '../../utils/dir.dart';
import '../../widgets/post_container.dart';
import '../../utils/parse.dart';
import '../read.dart';
import '../../models/post.dart';
import 'edit_feed_page.dart';

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
                  child: const Text('全标已读'),
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
                  child: const Text('编辑订阅'),
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
                          title: const Text('删除订阅'),
                          content: const Text('确定要删除该订阅吗？'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await widget.feed.deleteFromDb();
                                if (!mounted) return;
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('确定'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('删除订阅'),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  parseFeed ? '更新成功' : '更新失败',
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                action: SnackBarAction(label: '确定', onPressed: () {}),
              ),
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
