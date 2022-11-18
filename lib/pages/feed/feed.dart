import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meread/widgets/post_container.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:meread/utils/db.dart';
import 'package:meread/utils/parse.dart';
import 'package:meread/pages/feed/edit_feed.dart';
import 'package:meread/pages/read.dart';
import 'package:meread/models/models.dart';
import 'package:meread/utils/key.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.feed});
  final Feed feed;
  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  List<Post> postList = [];
  bool onlyUnread = false;
  Map<String, dynamic> readPageInitData = {};

  Future<void> getPostList() async {
    List<Post> postsList = await postsByFeedId(widget.feed.id!);
    setState(() {
      postList = postsList;
    });
  }

  Future<void> getUnreadPostList() async {
    List<Post> postsList = await unreadPostsByFeedId(widget.feed.id!);
    setState(() {
      postList = postsList;
      onlyUnread = true;
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
    getPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.feed.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () async {
                    await markFeedPostsAsRead(widget.feed.id!);
                    if (onlyUnread) {
                      await getUnreadPostList();
                    } else {
                      await getPostList();
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
                      await getUnreadPostList();
                    }
                  },
                  child: Text(
                    onlyUnread ? '显示全部' : '只看未读',
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
                          builder: (context) => EditFeedPage(feed: widget.feed),
                        ),
                      );
                    });
                  },
                  child: Text(
                    '编辑订阅',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                // 删除订阅源
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(const Duration(seconds: 0), () {
                      deleteFeed(widget.feed.id!);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    '删除订阅',
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
      body: RefreshIndicator(
        onRefresh: () async {
          bool parseFeed = await parseFeedContent(widget.feed);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                parseFeed ? '更新成功' : '更新失败',
                textAlign: TextAlign.center,
              ),
              duration: const Duration(seconds: 1),
            ),
          );
          if (onlyUnread) {
            getUnreadPostList();
          } else {
            getPostList();
          }
        },
        child: ListView.separated(
          itemCount: postList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                if (postList[index].openType == 2) {
                  await launchUrl(
                    Uri.parse(postList[index].link),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  getReadPageInitData();
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ReadPage(
                          post: postList[index], initData: readPageInitData),
                    ),
                  ).then((value) {
                    if (onlyUnread) {
                      getUnreadPostList();
                    } else {
                      getPostList();
                    }
                  });
                }
                // 标记文章为已读
                markPostAsRead(postList[index].id!);
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
