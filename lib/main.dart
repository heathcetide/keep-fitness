
import 'package:demo_project/pages/fitness_app/fitness_app_home_screen.dart';
import 'package:demo_project/pages/fitness_app/mine/profile.dart';
import 'package:demo_project/pages/fitness_app/mine/profile_info.dart';
import 'package:demo_project/pages/introduction_animation/introduction_animation_screen.dart';
import 'package:demo_project/pages/logger/logger.dart';
import 'package:demo_project/pages/profile/about_page.dart';
import 'package:demo_project/pages/profile/avatar_upload.dart';
import 'package:demo_project/pages/profile/feedback_page.dart';
import 'package:demo_project/pages/profile/infomation.dart';
import 'package:demo_project/pages/profile/setting.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/pages/login/login.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get_storage/get_storage.dart';

import 'common/logger.dart';

//程序入口点
void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

//MyAPP 继承StatelessWidget 表示一个无状态的部件，返回一个MaterialApp 包含应用程序的基本结构和设计的部件
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AppLogger.log("This is an info message");
    try {
      int a = (1 / 0) as int;
    } catch (e, stackTrace) {
      AppLogger.error("An error was caught", e, stackTrace);
    }
    AppLogger.warning("This is a warning message This is a warning message This is a warning message This is a warning message This is a warning message This is a warning message This is a warning message This is a warning message This is a warning message This is a warning message This is a warning message This is a warning message");
    AppLogger.debug("This is a debug message");
    AppLogger.verbose("This is a verbose message");
    //MaterialApp提供应用的主题，路由和其他全局配置
    return MaterialApp(
      title: 'CodeForge',
      // 在 MaterialApp 主题中配置
      theme: _buildThemeData(),
      // 定义路由表
      routes: _buildRoutes(),
      initialRoute: '/login',
      // 设置初始路由
      builder: (context, child) {
        return FlutterSmartDialog(child: child!);
      },
    );
  }

  // 构建主题数据
  ThemeData _buildThemeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 101, 218, 206),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.teal, // 全局 AppBar 背景颜色
        foregroundColor: Colors.white, // 全局文字颜色
      ),
      useMaterial3: true,
    );
  }

  // 配置路由
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/': (context) => FitnessAppHomeScreen(),
      '/login': (context) => LoginScreen(),
      '/profile_detail': (context) => ProfileInfoView(),
      '/settings': (context) => const SettingsPage(),
      '/logger': (context) => LogPage(),
      '/profile/feedback': (context) => FeedbackPage(),  // 反馈页面
      '/profile/about': (context) => AboutPage(),
      '/profile/avatarUpload': (context) => AvatarUpload(),
      '/introduction_animation': (context) => IntroductionAnimationScreen(),
    };
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
