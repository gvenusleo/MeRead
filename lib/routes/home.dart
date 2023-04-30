import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/post_container.dart';
import '../models/feed.dart';
import '../utils/parse.dart';
import 'feed_page/add_feed_page.dart';
import 'feed_page/feed_page.dart';
import '../../routes/read.dart';
import 'setting_page/setting_page.dart';
import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Map<String, List<Feed>> feedListGroupByCategory = {};
  List<Post> postList = [];
  bool onlyUnread = false;
  bool onlyFavorite = false;
  Map<int, int> unreadCount = {};

  Future<void> getFeedList() async {
    await Feed.groupByCategory().then(
      (value) => setState(
        () {
          feedListGroupByCategory = value;
        },
      ),
    );
  }

  Future<void> getPostList() async {
    await Post.getAll().then(
      (value) => setState(
        () {
          postList = value;
        },
      ),
    );
  }

  Future<void> getUnreadPost() async {
    await Post.getUnread().then(
      (value) => setState(
        () {
          postList = value;
        },
      ),
    );
  }

  Future<void> getFavoritePost() async {
    await Post.getAllFavorite().then(
      (value) => setState(
        () {
          postList = value;
        },
      ),
    );
  }

  Future<void> getUnreadCount() async {
    await Feed.unreadPostCount().then(
      (value) => setState(
        () {
          unreadCount = value;
        },
      ),
    );
  }

  Future<void> refresh() async {
    List<Feed> feedList = await Feed.getAll();
    int failCount = 0;
    await Future.wait(
      feedList.map(
        (e) => parseFeedContent(e).then(
          (value) async {
            if (value) {
              if (onlyUnread) {
                await getUnreadPost();
              } else if (!onlyFavorite) {
                await getPostList();
              }
              await getUnreadCount();
            } else {
              failCount++;
            }
          },
        ),
      ),
    );
    if (failCount > 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('更新失败 $failCount 个订阅源'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('更新成功'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getFeedList();
    getPostList();
    getUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('悦读'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              if (onlyUnread) {
                await getPostList();
                setState(() {
                  onlyUnread = false;
                });
              } else {
                await getUnreadPost();
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
                await getFavoritePost();
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
                    await Post.markAllRead();
                    if (onlyUnread) {
                      getUnreadPost();
                    } else if (onlyFavorite) {
                      getFavoritePost();
                    } else {
                      getPostList();
                    }
                    getUnreadCount();
                  },
                  child: const Text('全标已读'),
                ),
                PopupMenuItem(
                  onTap: () {
                    // 打开订阅源添加页面，返回时刷新订阅源列表
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AddFeedPage(),
                        ),
                      ).then((value) => getFeedList());
                    });
                  },
                  child: const Text('添加订阅'),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SettingPage(),
                        ),
                      ).then((value) {
                        getFeedList();
                        if (onlyUnread) {
                          getUnreadPost();
                        } else if (onlyFavorite) {
                          getFavoritePost();
                        } else {
                          getPostList();
                        }
                      });
                    });
                  },
                  child: const Text('设置'),
                ),
              ];
            },
          ),
        ],
      ),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.4,
      drawer: Drawer(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 18),
            itemCount: feedListGroupByCategory.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionTile(
                title: Text(
                  feedListGroupByCategory.keys.toList()[index],
                ),
                shape: Border.all(color: Colors.transparent),
                children: [
                  Column(
                    children: [
                      for (Feed feed
                          in feedListGroupByCategory.values.toList()[index])
                        ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(
                            left: 40,
                            right: 28,
                          ),
                          title: Text(
                            feed.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            unreadCount[feed.id] == null
                                ? ''
                                : unreadCount[feed.id].toString(),
                          ),
                          onTap: () {
                            if (!mounted) return;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => FeedPage(feed: feed),
                              ),
                            ).then((value) {
                              getFeedList();
                              getUnreadCount();
                              if (onlyUnread) {
                                getUnreadPost();
                              } else if (onlyFavorite) {
                                getFavoritePost();
                              } else {
                                getPostList();
                              }
                            });
                          },
                        ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.separated(
            cacheExtent: 30, // 预加载
            itemCount: postList.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              return GestureDetector(
                // 根据 openType 打开文章
                onTap: () async {
                  if (postList[index].openType == 2) {
                    // 系统浏览器打开
                    await launchUrl(
                      Uri.parse(postList[index].link),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    // 应用内打开：阅读器 or 标签页
                    final bool fullText =
                        await postList[index].getFullText() == 1;
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ReadPage(
                          post: postList[index],
                          fullText: fullText,
                        ),
                      ),
                    ).then((value) {
                      // 返回时刷新文章列表
                      if (onlyUnread) {
                        getUnreadPost();
                      } else if (onlyFavorite) {
                        getFavoritePost();
                      } else {
                        getPostList();
                      }
                      getUnreadCount();
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
