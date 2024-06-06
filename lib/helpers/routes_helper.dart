import 'package:get/get.dart';
import 'package:meread/ui/views/add_feed/add_feed_view.dart';
import 'package:meread/ui/views/edit_feed/edit_feed_view.dart';
import 'package:meread/ui/views/home_view.dart';
import 'package:meread/ui/views/post/post_view.dart';
import 'package:meread/ui/views/setting/about/about_view.dart';
import 'package:meread/ui/views/setting/data_manage/data_manage_view.dart';
import 'package:meread/ui/views/setting/display/display_setting_view.dart';
import 'package:meread/ui/views/setting/read/read_setting_view.dart';
import 'package:meread/ui/views/setting/resolve/resolve_setting_view.dart';
import 'package:meread/ui/views/setting/setting_view.dart';

class RouteHelp {
  static String get initRoute => '/';

  static final List<GetPage> routes = [
    GetPage(name: '/', page: () => const HomeView()),
    GetPage(name: '/post', page: () => const PostView()),
    GetPage(name: '/addFeed', page: () => const AddFeedView()),
    GetPage(name: '/editFeed', page: () => const EditFeedView()),
    GetPage(name: '/setting', page: () => const SettingView()),
    GetPage(name: '/setting/display', page: () => const DisplaySettingView()),
    GetPage(name: '/setting/read', page: () => const ReadSettingView()),
    GetPage(name: '/setting/resolve', page: () => const ResolveSettingView()),
    GetPage(name: '/setting/data_manage', page: () => const DataManageView()),
    GetPage(name: '/setting/about', page: () => const AboutView()),
  ];
}
