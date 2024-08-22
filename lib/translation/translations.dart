import 'package:get/get.dart';
import 'package:meread/translation/chinese.dart';
import 'package:meread/translation/english.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': chinese,
        'en_US': english,
      };
}
