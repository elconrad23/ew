import 'package:enviroewatch/helper/connectivity.dart';
import 'package:enviroewatch/helper/responsive_helper.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/profile_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/view/screens/home/home_screen.dart';
import 'package:enviroewatch/view/screens/home/reports_screen.dart';
import 'package:enviroewatch/view/screens/menu/widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final CustomDrawerController drawerController;
  MainScreen({required this.drawerController});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> _screens = [];
  List<String> _keys = [];

  @override
  void initState() {
    super.initState();

    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    } else {}
    ResponsiveHelper.isWeb()
        ? SizedBox()
        : NetworkInfo.checkConnectivity(context);

    _screens = [HomeScreen(key: Key("home_screen.dart"),), ReportScreen(key: Key("reports_screen.dart"),)];
    _keys = ['home', 'report'];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return WillPopScope(
          onWillPop: () async {
            if (splash.pageIndex != 0) {
              splash.setPageIndex(0);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: _screens[splash.pageIndex],
          ),
        );
      },
    );
  }
}
