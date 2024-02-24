import 'package:get/get.dart';
import 'package:meread/ui/views/add_feed/add_feed_view.dart';
import 'package:meread/ui/views/edit_feed/edit_feed_view.dart';
import 'package:meread/ui/views/home_view.dart';
import 'package:meread/ui/views/post/post_view.dart';
import 'package:meread/ui/views/setting/about/about_view.dart';
import 'package:meread/ui/views/setting/block/block_setting_view.dart';
import 'package:meread/ui/views/setting/language/language_seting_view.dart';
import 'package:meread/ui/views/setting/proxy/proxy_setting_view.dart';
import 'package:meread/ui/views/setting/read/read_setting_view.dart';
import 'package:meread/ui/views/setting/refresh/refresh_setting_view.dart';
import 'package:meread/ui/views/setting/screen_refresh_rate/screen_refresh_rate_setting_view.dart';
import 'package:meread/ui/views/setting/setting_view.dart';
import 'package:meread/ui/views/setting/theme/theme_setting.view.dart';

class AppRputes {
  static final List<GetPage> routes = [
    /// 主页
    GetPage(name: '/', page: () => const HomeView()),

    /// 阅读页面
    GetPage(name: '/post', page: () => const PostView()),

    /// 添加订阅
    GetPage(name: '/addFeed', page: () => const AddFeedView()),

    /// 编辑订阅
    GetPage(name: '/editFeed', page: () => const EditFeedView()),

    /// 设置
    GetPage(name: '/setting', page: () => const SettingView()),
    // 语言设置
    GetPage(name: '/setting/language', page: () => const LanguageSettingView()),
    // 主题设置
    GetPage(name: '/setting/theme', page: () => ThemeSettingView()),
    // 屏幕刷新率设置
    GetPage(
        name: '/setting/screenRefreshRate',
        page: () => const ScreenRefreshRateSettingView()),
    // 阅读设置
    GetPage(name: '/setting/read', page: () => const ReadSettingView()),
    // 刷新设置
    GetPage(name: '/setting/refresh', page: () => const RefreshSettingView()),
    // 屏蔽设置
    GetPage(name: '/setting/block', page: () => const BlockSettingView()),
    // 代理设置
    GetPage(name: '/setting/proxy', page: () => const ProxySettingView()),
    // 关于应用
    GetPage(name: '/setting/about', page: () => const AboutView()),
  ];
}
