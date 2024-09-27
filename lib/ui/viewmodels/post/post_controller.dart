import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_main_element/html_main_element.dart';
import 'package:meread/helpers/dio_helper.dart';
import 'package:meread/helpers/isar_helper.dart';
import 'package:meread/helpers/log_helper.dart';
import 'package:meread/models/post.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PostController extends GetxController {
  late Rx<Post> post;
  RxBool fullTexting = false.obs;

  PostController(Post p) {
    p.read = true;
    IsarHelper.putPost(p);
    post = p.obs;
    if ((post.value.feed.value?.fullText ?? false) && !post.value.fullText) {
      fullTexting.value = true;
      getFullText();
    }
  }

  void openInBrowser() {
    launchUrlString(
      post.value.link,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> getFullText() async {
    fullTexting.value = true;
    try {
      final response = await DioHelper.get(post.value.link);
      final document = html_parser.parse(response.data.toString());
      if (document.documentElement == null) return;
      final mainElement = readabilityMainElement(document.documentElement!);
      post.value.content = mainElement.outerHtml;
      fullTexting.value = false;
      IsarHelper.putPost(post.value);
    } catch (e) {
      LogHelper.e(e.toString());
    }
  }

  void markAsUnread() {
    post.value.read = false;
    IsarHelper.putPost(post.value);
  }

  void changeFavorite() {
    post.value.favorite = !post.value.favorite;
    IsarHelper.putPost(post.value);
  }
}
