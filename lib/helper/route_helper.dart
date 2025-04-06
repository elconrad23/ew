import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:enviroewatch/view/screens/auth/create_account_screen.dart';
import 'package:enviroewatch/view/screens/auth/login_screen.dart';
import 'package:enviroewatch/view/screens/home/home_screen.dart';
import 'package:enviroewatch/view/screens/home/reports_screen.dart';
import 'package:enviroewatch/view/screens/menu/menu_screen.dart';
import 'package:enviroewatch/view/screens/splash/splash_screen.dart';

class RouteHelper {
  static final FluroRouter router = FluroRouter();

  // Route paths
  static const String splash = '/splash';
  static const String menu = '/';
  static const String home = '/home';
  static const String report = '/report';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String notification = '/notification';
  static const String profile = '/profile';
  static const String profileEdit = '/profile-edit';
  static const String profileMenus = '/menus';
  static const String aboutUs = '/about-us';
  static const String verification = '/verification';
  static const String resetPassword = '/reset-password';

  // Getters for routes
  static String getMainRoute() => menu;
  static String getHomeRoute() => home;
  static String getReportRoute() => report;
  static String getLoginRoute() => login;
  static String getNotificationRoute() => notification;
  static String getAboutUsRoute() => aboutUs;

  static String getVerifyRoute(String page, String email) =>
      '$verification?page=$page&email=$email';

  static String getNewPassRoute(String email, String token) =>
      '$resetPassword?email=$email&token=$token';

  static String getProfileEditRoute(String phone) => '$profileEdit?phone=$phone';

  // Route Handlers
  static final Handler _menuHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => MenuScreen(),
  );

  static final Handler _splashHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => SplashScreen(),
  );

  static final Handler _reportHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => ReportScreen(key: Key("report"),),
  );

  static final Handler _homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => HomeScreen(key: Key("home"),),
  );

  static final Handler _loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => LoginScreen(),
  );

  static final Handler _createAccountHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) => CreateAccountScreen(),
  );

  // Router Setup
  static void setupRouter() {
    router.define(splash, handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(menu, handler: _menuHandler, transitionType: TransitionType.fadeIn);
    router.define(home, handler: _homeHandler, transitionType: TransitionType.fadeIn);
    router.define(report, handler: _reportHandler, transitionType: TransitionType.fadeIn);
    router.define(login, handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(createAccount, handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
  }
}
