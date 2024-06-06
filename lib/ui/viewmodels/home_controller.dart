import 'package:flutter/material.dart';
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
      // TODO： show toast
      return;
    }
    List<int> result = await ResolveHelper.reslovePosts(feeds);
    getPosts();
    if (result[1] > 0) {
      // TODO: show toast
    } else {
      Get.snackbar(
        'refreshSuccess'.tr,
        'refreshSuccessInfo'.trParams({'count': result[0].toString()}),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  Future<void> focusAllFeeds() async {
    List<Feed> tem = [];
    // feedsGroupByCategory.forEach((key, value) {
    //   tem.addAll(value);
    // });
    feeds.value = tem;
    await getPosts();
    onlyUnread.value = false;
    onlyFavorite.value = false;
    appBarTitle.value = 'MeRead'.tr;
    Get.back();
  }

  // 定位到指定分类
  Future<void> focusCategory(String category) async {
    // feeds.value = feedsGroupByCategory[category] ?? '';
    await getPosts();
    onlyUnread.value = false;
    onlyFavorite.value = false;
    appBarTitle.value = category;
    Get.back();
  }

  // 定位到指定订阅源
  Future<void> focusFeed(Feed feed) async {
    feeds.value = [feed];
    await getPosts();
    onlyUnread.value = false;
    onlyFavorite.value = false;
    appBarTitle.value = feed.title;
    Get.back();
  }

  // 未读筛选
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

  // 收藏筛选
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

  // 修改单一 Post 阅读状态
  void updateReadStatus(Post post) {
    final int index = postList.indexOf(post);
    IsarHelper.updatePostRead(post);
    postList[index] = post;
  }

  // 全标已读
  void markAllRead() {
    IsarHelper.markAllRead(postList);
    getPosts();
  }

  // 添加订阅源
  void toAddFeed() {
    Get.toNamed('/addFeed')?.then((_) => getFeeds().then((_) {
          getPosts();
          getUnreadCount();
        }));
  }

  // 应用设置
  void toSetting() {
    Get.toNamed('/setting')?.then((_) => getFeeds().then((_) {
          getPosts();
          getUnreadCount();
        }));
  }

  // 跳转编辑订阅
  void toEditFeed(Feed value) {
    Get.toNamed('/editFeed', arguments: value)
        ?.then((_) => getFeeds().then((_) {
              getPosts();
              getUnreadCount();
            }));
  }
}
