import 'dart:async';
import 'dart:io';

import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/localization_provider.dart';
import 'package:enviroewatch/provider/profile_provider.dart';
import 'package:enviroewatch/provider/report_provider.dart';
import 'package:enviroewatch/theme/light_theme.dart';
import 'package:enviroewatch/view/screens/auth/login_screen.dart';
import 'package:enviroewatch/view/screens/menu/menu_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/app_constants.dart';
import 'di_container.dart' as di;
import 'helper/notification_helper.dart';
import 'helper/route_helper.dart';
import 'provider/theme_provider.dart';

final FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
    (Platform.isAndroid || Platform.isIOS)
        ? FlutterLocalNotificationsPlugin()
        : null;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        authDomain: "YOUR_PROJECT.firebaseapp.com",
        projectId: "YOUR_PROJECT_ID",
        storageBucket: "YOUR_PROJECT.appspot.com",
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
        appId: "YOUR_APP_ID",
        measurementId: "YOUR_MEASUREMENT_ID",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await di.init();
  try {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.getInitialMessage();
      await NotificationHelper.initialize(
          flutterLocalNotificationsPlugin!, kIsWeb, MyApp.navigatorKey);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {}

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ReportProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
    ],
    child: MyApp(isWeb: !kIsWeb),
  ));
}

class MyApp extends StatefulWidget {
  final bool isWeb;
  MyApp({required this.isWeb});

  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouteHelper.setupRouter();

    if (kIsWeb) {
      Future.microtask((){
        Provider.of<SplashProvider>(context, listen: false).initSharedData();
        _route();
      });
    }
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
      .initConfig(context)
      .then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 1), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false).updateToken();
            Navigator.of(context).pushReplacementNamed(RouteHelper.menu,
                arguments: MenuScreen());
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteHelper.login, (route) => false,
                arguments: LoginScreen());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return MaterialApp(
          title: AppConstants.APP_NAME,
          initialRoute: RouteHelper.splash,
          onGenerateRoute: RouteHelper.router.generator,
          debugShowCheckedModeBanner: false,
          navigatorKey: MyApp.navigatorKey,
          theme: light,
        );
      },
    );
  }
}
