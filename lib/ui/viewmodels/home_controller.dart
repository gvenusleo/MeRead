import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/common/helpers/feed_helper.dart';
import 'package:meread/common/helpers/post_helper.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/models/post.dart';

class HomeController extends GetxController {
  // 订阅源列表，按分类分组
  RxMap feedsGroupByCategory = <String, List<Feed>>{}.obs;
  // 每个订阅源未读 Post 数量
  RxMap<Feed, int> unreadCount = <Feed, int>{}.obs;
  // 当前查看的订阅源
  RxList<Feed> feeds = <Feed>[].obs;
  // 文章列表
  RxList<Post> postList = <Post>[].obs;
  // 是否只显示未读文章
  RxBool onlyUnread = false.obs;
  // 是否只显示收藏文章
  RxBool onlyFavorite = false.obs;
  // AppBar 标题
  RxString appBarTitle = 'MeRead'.tr.obs;

  // 搜索控制器
  final searchController = SearchController();

  @override
  void onInit() {
    super.onInit();
    getFeeds().then((_) => getPosts());
    getUnreadCount();
  }

  // 获取订阅源
  Future<void> getFeeds() async {
    feeds.value = await FeedHelper.getFeeds();
    final Map<String, List<Feed>> result = {};
    for (final Feed feed in feeds) {
      if (result.containsKey(feed.category)) {
        result[feed.category]!.add(feed);
      } else {
        result[feed.category] = [feed];
      }
    }
    feedsGroupByCategory.value = result;
    appBarTitle.value = 'MeRead'.tr;
  }

  // 获取未读数量
  Future<void> getUnreadCount() async {
    final List<Post> posts = await PostHelper.getAllPosts();
    final Map<Feed, int> result = {};
    for (final Feed feed in feeds) {
      final int count =
          posts.where((p) => p.feed.value?.id == feed.id && !p.read).length;
      result[feed] = count;
    }
    unreadCount.value = result;
  }

  // 获取分类总未读数量
  int getCategoryUnreadCount(String category) {
    int result = 0;
    feedsGroupByCategory[category]?.forEach((feed) {
      result += unreadCount[feed] ?? 0;
    });
    return result;
  }

  // 获取 Post
  Future<void> getPosts() async {
    postList.value = await PostHelper.getPostsByFeeds(feeds);
  }

  // 刷新订阅源
  Future<void> refreshPosts() async {
    if (feeds.isEmpty) {
      Get.snackbar(
        'noFeeds'.tr,
        'noFeedsInfo'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }
    List<int> result = await PostHelper.reslovePosts(feeds);
    getPosts();
    if (result[1] > 0) {
      Get.snackbar(
        'refreshError'.tr,
        'refreshErrorInfo'.trParams({'count': result[1].toString()}),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    } else {
      Get.snackbar(
        'refreshSuccess'.tr,
        'refreshSuccessInfo'.trParams({'count': result[0].toString()}),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  // 定位到全部订阅源
  Future<void> focusAllFeeds() async {
    List<Feed> tem = [];
    feedsGroupByCategory.forEach((key, value) {
      tem.addAll(value);
    });
    feeds.value = tem;
    await getPosts();
    onlyUnread.value = false;
    onlyFavorite.value = false;
    appBarTitle.value = 'MeRead'.tr;
    Get.back();
  }

  // 定位到指定分类
  Future<void> focusCategory(String category) async {
    feeds.value = feedsGroupByCategory[category] ?? '';
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
      postList.value = (await PostHelper.getPostsByFeeds(feeds))
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
      postList.value = (await PostHelper.getPostsByFeeds(feeds))
          .where((p) => p.favorite)
          .toList();
    }
  }

  // 修改单一 Post 阅读状态
  Future<void> updateReadStatus(Post post) async {
    final int index = postList.indexOf(post);
    await PostHelper.updatePostReadStatus(post);
    postList[index] = post;
  }

  // 全标已读
  Future<void> markAllRead() async {
    await PostHelper.mardPostsAsRead(postList);
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
