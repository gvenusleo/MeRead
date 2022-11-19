import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../utils/db.dart';

Future<bool> send2flomo(
  String text,
  Map<String, dynamic> initData,
  Post post,
) async {
  // 解决 \n 无法换行的问题
  text = text.replaceAll(r'\n', '\n');
  if (initData['useCategoryAsTag']) {
    String categoryName = await feedCategory(post.feedId);
    text = '$text\n#$categoryName';
  } else {
    if (initData['flomoTag'] != '') {
      text = "$text\n#${initData['flomoTag']}";
    }
  }
  if (initData['endAddLink']) {
    text = '$text\nvia ${post.link}';
  }
  try {
    final response = await http.post(
      Uri.parse(initData['flomoApiKey']),
      body: {'content': text},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
