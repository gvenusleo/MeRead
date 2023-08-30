import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:meread/routes/feed_page/add_feed_page.dart';
import 'package:meread/routes/feed_page/feed_page.dart';
import 'package:meread/routes/read.dart';
import 'package:meread/routes/setting_page/setting_page.dart';
import 'package:meread/utils/font_util.dart';
import 'package:meread/utils/parse_post_util.dart';
import 'package:meread/widgets/post_container.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // 订阅源列表，按分类分组
  Map<String, List<Feed>> feedListGroupByCategory = {};
  // 文章列表
  List<Post> postList = [];
  // 是否只显示未读文章
  bool onlyUnread = false;
  // 是否只显示收藏文章
  bool onlyFavorite = false;
  // 未读文章数
  Map<int, int> unreadCount = {};
  // 字体目录
  String? fontDir;

  /* 获取订阅源列表 */
  Future<void> getFeedList() async {
    await Feed.groupByCategory().then(
      (value) => setState(
        () {
          feedListGroupByCategory = value;
        },
      ),
    );
  }

  /* 获取文章列表 */
  Future<void> getPostList() async {
    await Post.getAll().then(
      (value) => setState(
        () {
          postList = value;
        },
      ),
    );
  }

  /* 获取未读文章列表 */
  Future<void> getUnreadPost() async {
    await Post.getUnread().then(
      (value) => setState(
        () {
          postList = value;
        },
      ),
    );
  }

  /* 获取收藏文章列表 */
  Future<void> getFavoritePost() async {
    await Post.getFavorite().then(
      (value) => setState(
        () {
          postList = value;
        },
      ),
    );
  }

  /* 获取未读文章数 */
  Future<void> getUnreadCount() async {
    await Feed.unreadPostCount().then(
      (value) => setState(
        () {
          unreadCount = value;
        },
      ),
    );
  }

  /* 刷新文章列表 */
  Future<void> refresh() async {
    List<Feed> feedList = await Feed.getAll();

    // 刷新失败的订阅源数量
    int failCount = 0;

    await Future.wait(
      feedList.map(
        (e) => parsePosts(e).then(
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
    if (!mounted) return;
    Fluttertoast.showToast(
      msg: failCount > 0
          ? AppLocalizations.of(context)!.updateFailedFeeds(failCount)
          : AppLocalizations.of(context)!.updateSuccess,
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
    getFeedList();
    getPostList();
    getUnreadCount();
    initFontDir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.meRead),
        centerTitle: false,
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
          /* 收藏筛选 */
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
                /* 全标已读 */
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
                  child: Text(AppLocalizations.of(context)!.markAllAsRead),
                ),
                /* 添加订阅源 */
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
                  child: Text(AppLocalizations.of(context)!.addFeed),
                ),
                const PopupMenuDivider(),
                /* 设置 */
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
                  child: Text(AppLocalizations.of(context)!.settings),
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
            itemCount: postList.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              return GestureDetector(
                /* 根据 openType 打开文章 */
                onTap: () async {
                  if (postList[index].openType == 2) {
                    /* 系统浏览器打开 */
                    await launchUrl(
                      Uri.parse(postList[index].link),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    /* 应用内打开：阅读器 or 标签页 */
                    if (!mounted) return;
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
                      /* 返回时刷新文章列表 */
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
