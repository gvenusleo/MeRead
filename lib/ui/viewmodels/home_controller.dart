import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/helpers/resolve_helper.dart';
import 'package:meread/models/category.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';

class HomeController extends GetxController {
  RxList<Category> categorys = <Category>[].obs;
  RxMap<Feed, int> unreadCount = <Feed, int>{}.obs;
  RxList<Feed> feeds = <Feed>[].obs;
  RxList<Post> postList = <Post>[].obs;
  RxBool onlyUnread = false.obs;
  RxBool onlyFavorite = false.obs;
  RxString appBarTitle = 'MeRead'.tr.obs;

  final searchController = SearchController();

  @override
  void onInit() {
    super.onInit();
    getFeeds().then((_) => getPosts());
    getUnreadCount();
  }

  Future<void> getFeeds() async {
    feeds.value = await IsarHelper.getFeeds();
    categorys.value = await IsarHelper.getCategorys();
    appBarTitle.value = 'MeRead'.tr;
  }

  Future<void> getUnreadCount() async {
    final List<Post> posts = await IsarHelper.getPosts();
    final Map<Feed, int> result = {};
    for (final Feed feed in feeds) {
      final int count =
          posts.where((p) => p.feed.value?.id == feed.id && !p.read).length;
      result[feed] = count;
    }
    unreadCount.value = result;
  }

  Future<void> getPosts() async {
    postList.value = await IsarHelper.getPostsByFeeds(feeds);
  }

  Future<void> refreshPosts() async {
    if (feeds.isEmpty) {
      Fluttertoast.showToast(msg: 'FeedIsEmpty'.tr);
      return;
    }
    List<int> result = await ResolveHelper.reslovePosts(feeds);
    getPosts();
    if (result[1] > 0) {
      Fluttertoast.showToast(
        msg: 'refreshFailed'.trParams({'count': result[1].toString()}),
      );
    } else {
      Fluttertoast.showToast(msg: 'refreshSuccess'.tr);
    }
  }

  Future<void> focusAllFeeds() async {
    List<Feed> tem = [];
    feeds.value = tem;
    await getPosts();
    onlyUnread.value = false;
    onlyFavorite.value = false;
    appBarTitle.value = 'MeRead'.tr;
    Get.back();
  }

  // get unread post count by category
  // int getUnreadCountByCategory(Category category) {
  //   int count = 0;
  //   for (final Feed feed in category.feeds) {
  //     count += unreadCount[feed] ?? 0;
  //   }
  //   return count;
  // }

  // Focus on a category
  Future<void> focusCategory(Category category) async {
    feeds.value = category.feeds.toList();
    await getPosts();
    onlyUnread.value = false;
    onlyFavorite.value = false;
    appBarTitle.value = category.name;
    Get.back();
  }

  // Focus on a feed
  // Future<void> focusFeed(Feed feed) async {
  //   feeds.value = [feed];
  //   await getPosts();
  //   onlyUnread.value = false;
  //   onlyFavorite.value = false;
  //   appBarTitle.value = feed.title;
  //   Get.back();
  // }

  // Filter unread
  Future<void> filterUnread() async {
    if (onlyUnread.value) {
      onlyUnread.value = false;
      getPosts();
    } else {
      onlyUnread.value = true;
      onlyFavorite.value = false;
      postList.value = (await IsarHelper.getPostsByFeeds(feeds))
          .where((p) => p.read == false)
          .toList();
    }
  }

  // Filter favorite
  Future<void> filterFavorite() async {
    if (onlyFavorite.value) {
      onlyFavorite.value = false;
      getPosts();
    } else {
      onlyFavorite.value = true;
      onlyUnread.value = false;
      postList.value = (await IsarHelper.getPostsByFeeds(feeds))
          .where((p) => p.favorite)
          .toList();
    }
  }

  // Update a Post read status
  void updateReadStatus(Post post) {
    final int index = postList.indexOf(post);
    IsarHelper.updatePostRead(post);
    postList[index] = post;
  }

  // Mark all posts as read
  void markAllRead() {
    IsarHelper.markAllRead(postList);
    getPosts();
  }

  // Go to add feed view
  void toAddFeed() {
    Get.toNamed('/addFeed')?.then((_) => getFeeds().then((_) {
          getPosts();
          getUnreadCount();
        }));
  }

  // Go to setting view
  void toSetting() {
    Get.toNamed('/setting')?.then((_) => getFeeds().then((_) {
          getPosts();
          getUnreadCount();
        }));
  }

  // Go to edit feed view
  void toEditFeed(Feed value) {
    Get.toNamed('/editFeed', arguments: value)
        ?.then((_) => getFeeds().then((_) {
              getPosts();
              getUnreadCount();
            }));
  }
}
