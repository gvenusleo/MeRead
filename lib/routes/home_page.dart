import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';
import 'package:meread/routes/feed_page/add_feed_page.dart';
import 'package:meread/routes/feed_page/edit_feed_page.dart';
import 'package:meread/routes/read_page.dart';
import 'package:meread/routes/setting_page/setting_page.dart';
import 'package:meread/utils/dir_util.dart';
import 'package:meread/utils/notification_util.dart';
import 'package:meread/utils/open_url_util.dart';
import 'package:meread/utils/parse_post_util.dart';
import 'package:meread/widgets/expansion_card.dart';
import 'package:meread/widgets/post_container.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // 订阅源列表，按分类分组
  Map<String, List<Feed>> feedListGroupByCategory = {};
  // 当前状态下的订阅源列表
  List<Feed> feedList = [];
  // 当前状态下的全部文章列表
  List<Post> postList = [];
  // 当前状态下的未读文章列表
  List<Post> unreadPostList = [];
  // 当前状态下的收藏文章列表
  List<Post> favoritePostList = [];
  // 是否只显示未读文章
  bool onlyUnread = false;
  // 是否只显示收藏文章
  bool onlyFavorite = false;
  // 未读文章数
  Map<int, int> unreadCount = {};
  // 字体目录
  String? fontDir;
  // Drawer 展开状态
  Map<String, bool> drawerExpansionState = {};
  // AppBar 标题
  String? appBarTitle;
  // 当前阅读的 POst
  Post? selectedPost;
  // 旋转动画控制器
  late AnimationController _animationController;
  // 旋转动画
  late Animation<double> _animation;
  // 左侧 Feeds 列表宽度
  double feedsListViewWidth = 240;
  // 中间 Posts 列表宽度
  double postsListViewWidth = 400;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
    super.initState();
    initData(setAppBar: false);
    initFontDir();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.4,
      drawer: buildDrawer(),
      body: buildBody(
        onlyUnread
            ? unreadPostList
            : (onlyFavorite ? favoritePostList : postList),
      ),
    );
  }

  /* 构建 AppBar */
  PreferredSizeWidget? buildAppBar() {
    if (Platform.isAndroid) {
      return buildAppBarHelper();
    } else {
      return null;
    }
  }

  PreferredSizeWidget buildAppBarHelper() {
    return AppBar(
      title: Text(
        appBarTitle == null
            ? AppLocalizations.of(context)!.allFeed
            : appBarTitle!,
      ),
      centerTitle: false,
      actions: [
        /* 刷新(仅 Windows) */
        if (Platform.isWindows)
          IconButton(
            onPressed: () async {
              _animationController.repeat();
              await refresh();
              _animationController.stop();
            },
            icon: RotationTransition(
              turns: _animation,
              child: const Icon(Icons.sync_outlined),
            ),
          ),
        /* 未读筛选 */
        IconButton(
          onPressed: filterUnread,
          icon: onlyUnread
              ? const Icon(Icons.radio_button_checked)
              : const Icon(Icons.radio_button_unchecked),
        ),
        /* 收藏筛选 */
        IconButton(
          onPressed: filterFavorite,
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
                onTap: markAllReadFunc,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.done_all_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(AppLocalizations.of(context)!.markAllAsRead),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              /* 添加订阅源 */
              PopupMenuItem(
                onTap: addFeedFunc,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(AppLocalizations.of(context)!.addFeed),
                  ],
                ),
              ),
              /* 编辑订阅 */
              PopupMenuItem(
                onTap: editFeedFunc,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(AppLocalizations.of(context)!.editFeed),
                  ],
                ),
              ),
              /* 删除订阅 */
              PopupMenuItem(
                onTap: deleteFeedFunc,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete_outline, size: 20),
                    const SizedBox(width: 10),
                    Text(AppLocalizations.of(context)!.deleteFeed),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              /* 设置 */
              PopupMenuItem(
                onTap: settingFunc,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.settings_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(AppLocalizations.of(context)!.settings),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  /* 构建 Android Drawer */
  Widget? buildDrawer() {
    if (Platform.isAndroid) {
      return Drawer(child: buildFeedsListView());
    } else {
      return null;
    }
  }

  /* 构建 Post 列表 */
  Widget buildBody(List<Post> posts) {
    if (feedList.isEmpty &&
        appBarTitle != AppLocalizations.of(context)!.allFeed) {
      initData();
    }
    if (Platform.isAndroid) {
      return buildPostsListView(posts);
    } else {
      return Row(
        children: [
          SizedBox(
            width: feedsListViewWidth,
            child: buildFeedsListView(),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                feedsListViewWidth += details.delta.dx;
                if (feedsListViewWidth < 200) {
                  feedsListViewWidth = 200;
                } else if (feedsListViewWidth > 400) {
                  feedsListViewWidth = 400;
                }
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: SizedBox(
                width: 8,
                child: Center(
                  child: VerticalDivider(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: postsListViewWidth,
            child: Scaffold(
              appBar: buildAppBarHelper(),
              body: buildPostsListView(posts),
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                postsListViewWidth += details.delta.dx;
                if (postsListViewWidth < 300) {
                  postsListViewWidth = 300;
                } else if (postsListViewWidth > 600) {
                  postsListViewWidth = 600;
                }
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: SizedBox(
                width: 8,
                child: Center(
                  child: VerticalDivider(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: (selectedPost != null)
                ? ReadPage(post: selectedPost!, fontDir: fontDir!)
                : Center(
                    child: Text(AppLocalizations.of(context)!.noPostOpened),
                  ),
          )
        ],
      );
    }
  }

  /* 构建订阅源列表侧边栏 */
  Widget buildFeedsListView() {
    /* 计算全部未读文章数 */
    int allUnreadCount = 0;
    for (int count in unreadCount.values) {
      allUnreadCount += count;
    }
    /* 计算分组未读文章数 */
    Map<String, int> unreadCountByCategory = {};
    for (String category in feedListGroupByCategory.keys) {
      int count = 0;
      for (Feed feed in feedListGroupByCategory[category] ?? []) {
        if (unreadCount[feed.id] != null) {
          count += unreadCount[feed.id]!;
        }
      }
      unreadCountByCategory[category] = count;
    }
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: feedListGroupByCategory.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 32, right: 28),
              title: Text(AppLocalizations.of(context)!.allFeed),
              trailing: Text(allUnreadCount.toString()),
              onTap: () {
                initData();
                if (Platform.isAndroid) {
                  Navigator.pop(context);
                }
              },
            );
          }
          String groupTitle = feedListGroupByCategory.keys.toList()[index - 1];
          return ExpansionCard(
            title: Text(groupTitle),
            trailing: Text(
              unreadCountByCategory[
                      feedListGroupByCategory.keys.toList()[index - 1]]!
                  .toString(),
            ),
            initiallyExpanded: drawerExpansionState[groupTitle] ?? false,
            onExpansionChanged: (value) {
              setState(() {
                drawerExpansionState[groupTitle] = value;
              });
            },
            onTap: () {
              setState(() {
                appBarTitle = feedListGroupByCategory.keys.toList()[index - 1];
                feedList = feedListGroupByCategory.values.toList()[index - 1];
              });
              getAllPost();
              if (Platform.isAndroid) {
                Navigator.pop(context);
              }
            },
            children: [
              Column(
                children: [
                  for (Feed feed
                      in feedListGroupByCategory.values.toList()[index - 1])
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.only(
                        left: 36,
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
                        setState(() {
                          appBarTitle = feed.name;
                          feedList = [feed];
                        });
                        getAllPost();
                        if (Platform.isAndroid) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  /* 构建 Post 列表 */
  Widget buildPostsListView(List<Post> posts) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.separated(
          itemCount: posts.length,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          itemBuilder: (context, index) {
            return GestureDetector(
              /* 根据 openType 打开文章 */
              onTap: () async {
                if (posts[index].openType == 1) {
                  /* 在应用内标签页中打开 */
                  openUrl(posts[index].link);
                } else if (posts[index].openType == 2) {
                  /* 系统浏览器打开 */
                  launchUrl(
                    Uri.parse(posts[index].link),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  /* 应用内打开：阅读器 or 标签页 */
                  if (fontDir == null) return;
                  if (Platform.isAndroid) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ReadPage(
                          post: posts[index],
                          fontDir: fontDir!,
                        ),
                      ),
                    ).then((value) {
                      /* 返回时刷新文章列表 */
                      getAllPost();
                      getUnreadCount();
                    });
                  } else {
                    setState(() {
                      selectedPost = posts[index];
                    });
                  }
                }
                /* 更新文章信息 */
                if (!posts[index].read) {
                  posts[index].read = true;
                  posts[index].updateToDb();
                }
              },
              child: PostContainer(post: posts[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 4);
          },
        ),
      ),
    );
  }

  /* 获取分组订阅源列表和全部订阅源列表 */
  Future<void> getAllFeed() async {
    await Feed.groupByCategory().then(
      (value) => setState(
        () {
          feedListGroupByCategory = value;
        },
      ),
    );
    List<Feed> tem = [];
    for (var feeds in feedListGroupByCategory.values) {
      tem.addAll(feeds);
    }
    setState(() {
      feedList = tem;
    });
  }

  /* 获取文章列表 */
  Future<void> getAllPost() async {
    await Post.getAllByFeeds(feedList).then(
      (value) => setState(
        () {
          postList = value;
          unreadPostList = value.where((e) => !e.read).toList();
          favoritePostList = value.where((e) => e.favorite).toList();
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
    // 刷新失败的订阅源数量
    int failCount = 0;
    await Future.wait(
      feedList.map(
        (e) => parsePosts(e).then(
          (value) async {
            if (value) {
              await getAllPost();
              await getUnreadCount();
            } else {
              failCount++;
            }
          },
        ),
      ),
    );
    if (!mounted) return;
    showToastOrSnackBar(
      context,
      failCount > 0
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

  /* 初始化数据 */
  Future<void> initData({bool setAppBar = true}) async {
    if (setAppBar) {
      setState(() {
        appBarTitle = AppLocalizations.of(context)!.allFeed;
      });
    }
    getAllFeed().then((value) => getAllPost());
    getUnreadCount();
  }

  /* 未读筛选 */
  Future<void> filterUnread() async {
    if (onlyUnread) {
      setState(() {
        onlyUnread = false;
      });
    } else {
      setState(() {
        onlyUnread = true;
        onlyFavorite = false;
      });
    }
  }

  /* 收藏筛选 */
  Future<void> filterFavorite() async {
    if (onlyFavorite) {
      setState(() {
        onlyFavorite = false;
      });
    } else {
      setState(() {
        onlyFavorite = true;
        onlyUnread = false;
      });
    }
  }

  /* 全标已读 */
  Future<void> markAllReadFunc() async {
    await Post.markAllRead(unreadPostList);
    getAllPost();
    getUnreadCount();
  }

  /* 添加订阅源 */
  void addFeedFunc() {
    // 打开订阅源添加页面，返回时刷新订阅源列表
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const AddFeedPage(),
        ),
      ).then((value) {
        initData();
      });
    });
  }

  /* 编辑订阅 */
  Future<void> editFeedFunc() async {
    if (feedList.length == 1) {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => EditFeedPage(
              feed: feedList.first,
            ),
          ),
        ).then((value) {
          initData();
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: const Icon(Icons.edit_outlined),
            title: Text(AppLocalizations.of(context)!.editFeed),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (Feed feed in feedList)
                  ListTile(
                    title: Text(feed.name),
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(Duration.zero, () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => EditFeedPage(feed: feed),
                          ),
                        ).then(
                          (value) {
                            initData();
                          },
                        );
                      });
                    },
                  ),
              ],
            ),
            scrollable: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 8,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          );
        },
      );
    }
  }

  /* 删除订阅 */
  Future<void> deleteFeedFunc() async {
    if (feedList.length == 1) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: const Icon(Icons.warning_rounded),
            title: Text(
              AppLocalizations.of(context)!.deleteConfirmation,
            ),
            content: Text(
              AppLocalizations.of(context)!.doYouWantToDeleteThisFeed,
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
                  await feedList.first.deleteFromDb();
                  initData();
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        },
      );
    } else {
      List<Feed> deleteFeeds = [];
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setCheckState) {
              return AlertDialog(
                icon: const Icon(Icons.delete_outline_outlined),
                title: Text(
                  AppLocalizations.of(context)!.deleteFeed,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (Feed feed in feedList)
                      CheckboxListTile(
                        value: deleteFeeds.contains(feed),
                        title: Text(feed.name),
                        onChanged: (value) {
                          if (value!) {
                            setCheckState(() {
                              deleteFeeds.add(feed);
                            });
                          } else {
                            setCheckState(() {
                              deleteFeeds.remove(feed);
                            });
                          }
                        },
                      ),
                  ],
                ),
                scrollable: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      if (deleteFeeds == feedList) {
                        setCheckState(() {
                          deleteFeeds = [];
                        });
                      } else {
                        setCheckState(() {
                          deleteFeeds = feedList;
                        });
                      }
                    },
                    child: Text(
                      deleteFeeds == feedList
                          ? AppLocalizations.of(context)!.unSelectAll
                          : AppLocalizations.of(context)!.selectAll,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (deleteFeeds.isEmpty) {
                            Navigator.pop(context);
                            return;
                          }
                          if (!mounted) return;
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                icon: const Icon(
                                  Icons.warning_rounded,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .deleteConfirmation,
                                ),
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .doYouWantToDeleteTheseFeeds(
                                    deleteFeeds.length,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      for (Feed feed in deleteFeeds) {
                                        await feed.deleteFromDb();
                                      }
                                      initData();
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.ok,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.ok),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  /* 设置 */
  void settingFunc() {
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const SettingPage(),
        ),
      ).then((value) {
        setState(() {
          appBarTitle = AppLocalizations.of(context)!.allFeed;
        });
        getAllFeed().then((value) => getAllPost());
        getUnreadCount();
      });
    });
  }
}
