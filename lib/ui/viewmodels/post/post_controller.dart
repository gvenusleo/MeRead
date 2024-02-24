import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_main_element/html_main_element.dart';
import 'package:meread/common/global.dart';
import 'package:meread/common/helpers/post_helper.dart';
import 'package:meread/models/post.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PostController extends GetxController {
  late Rx<Post> post;
  RxBool fullTexting = false.obs;

  PostController(Post p) {
    p.read = true;
    PostHelper.savePost(p);
    post = p.obs;
    if ((post.value.feed.value?.fullText ?? false) && !post.value.fullText) {
      fullTexting.value = true;
      getFullText();
    }
  }

  // 在浏览器中打开
  void openInBrowser() {
    launchUrlString(
      post.value.link,
      mode: LaunchMode.externalApplication,
    );
  }

  // 获取全文
  Future<void> getFullText() async {
    fullTexting.value = true;
    Dio dio = appDio.dio;
    try {
      final response = await dio.get(post.value.link);
      final document = html_parser.parse(response.data.toString());
      if (document.documentElement == null) return;
      final mainElement = readabilityMainElement(document.documentElement!);
      post.value = Post(
        id: post.value.id,
        title: post.value.title,
        link: post.value.link,
        content: mainElement.outerHtml,
        pubDate: post.value.pubDate,
        read: post.value.read,
        favorite: post.value.favorite,
        fullText: true,
      )..feed.value = post.value.feed.value;
      fullTexting.value = false;
      await PostHelper.savePost(post.value);
    } catch (e) {
      logger.e(e);
    }
  }

  // 标记为未读
  Future<void> markAsUnread() async {
    post.value.read = false;
    await PostHelper.savePost(post.value);
  }

  // 更改收藏状态
  Future<void> changeFavorite() async {
    post.value = Post(
      id: post.value.id,
      title: post.value.title,
      link: post.value.link,
      content: post.value.content,
      pubDate: post.value.pubDate,
      read: post.value.read,
      favorite: !post.value.favorite,
      fullText: post.value.fullText,
    )..feed.value = post.value.feed.value;
    await PostHelper.savePost(post.value);
  }
}
