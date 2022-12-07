import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/post_container.dart';
import '../../utils/db.dart';
import '../utils/parse.dart';
import '../../utils/key.dart';
import '../../routes/feed/add_feed.dart';
import '../../routes/feed/feed.dart';
import '../../routes/read.dart';
import '../../routes/setting/set.dart';
import '../../models/models.dart';

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
  Map<String, dynamic> readPageInitData = {};

  Future<void> getFeedList() async {
    Map<String, List<Feed>> temp = await feedsGroupByCategory();
    setState(() {
      feedListGroupByCategory = temp;
    });
  }

  Future<void> getPostList() async {
    List<Post> temp = await posts();
    setState(() {
      postList = temp;
    });
  }

  Future<void> getUnreadPost() async {
    List<Post> temp = await unreadPosts();
    setState(() {
      postList = temp;
      onlyUnread = true;
      onlyFavorite = false;
    });
  }

  Future<void> getFavoritePost() async {
    List<Post> temp = await favoritePosts();
    setState(() {
      postList = temp;
      onlyFavorite = true;
      onlyUnread = false;
    });
  }

  Future<void> getReadPageInitData() async {
    final Map<String, dynamic> temp = await getAllReadPageInitData();
    setState(() {
      readPageInitData = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    getFeedList();
    getPostList();
    getReadPageInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '悦读',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () async {
                    await markAllPostsAsRead();
                    if (onlyUnread) {
                      getUnreadPost();
                    } else if (onlyFavorite) {
                      getFavoritePost();
                    } else {
                      getPostList();
                    }
                  },
                  child: Text(
                    '全标已读',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    if (onlyUnread) {
                      await getPostList();
                      setState(() {
                        onlyUnread = false;
                      });
                    } else {
                      await getUnreadPost();
                    }
                  },
                  child: Text(
                    onlyUnread ? '显示全部' : '只看未读',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    if (onlyFavorite) {
                      await getPostList();
                      setState(() {
                        onlyFavorite = false;
                      });
                    } else {
                      await getFavoritePost();
                    }
                  },
                  child: Text(
                    onlyFavorite ? '显示全部' : '查看收藏',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const PopupMenuDivider(),
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
                  child: Text(
                    '添加订阅',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SetPage(),
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
                        getReadPageInitData();
                      });
                    });
                  },
                  child: Text(
                    '设置',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ];
            },
            elevation: 1,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ],
      ),
      drawer: Drawer(
        // TODO: 订阅源显示未读文章数
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: ListView.builder(
            itemCount: feedListGroupByCategory.length,
            itemBuilder: (BuildContext context, int index) {
              // 可折叠的订阅源列表
              return ExpansionTile(
                title: Text(
                  feedListGroupByCategory.keys.toList()[index],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        feedListGroupByCategory.values.toList()[index].length,
                    itemBuilder: (BuildContext context, int index2) {
                      return ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                        dense: true,
                        title: Text(
                          feedListGroupByCategory.values
                              .toList()[index][index2]
                              .name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onTap: () {
                          if (!mounted) return;
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => FeedPage(
                                  feed: feedListGroupByCategory.values
                                      .toList()[index][index2]),
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
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          List<Feed> feedList = await feeds();
          int failCount = 0;
          Future.wait(
            feedList.map(
              (e) => parseFeedContent(e).then(
                (value) async {
                  if (value) {
                    if (onlyUnread) {
                      await getUnreadPost();
                    } else if (!onlyFavorite) {
                      await getPostList();
                    }
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
                content: Text(
                  '更新失败 $failCount 个订阅源',
                  textAlign: TextAlign.center,
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  '更新成功',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 1),
              ),
            );
          }
          // 保证订阅源的文章数不大于 feedMaxSaveCount
          final int feedMaxSaveCount = await getFeedMaxSaveCount();
          checkPostCount(feedMaxSaveCount);
        },
        child: ListView.separated(
          cacheExtent: 30, // 预加载
          itemCount: postList.length,
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
                      await feedFullText(postList[index].feedId) == 1;
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ReadPage(
                        post: postList[index],
                        initData: readPageInitData,
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
                  });
                }
                // 标记文章为已读
                if (postList[index].read == 0) {
                  markPostAsRead(postList[index].id!);
                }
              },
              child: PostContainer(post: postList[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 1,
            );
          },
        ),
      ),
    );
  }
}
