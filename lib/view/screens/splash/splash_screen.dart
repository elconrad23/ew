import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enviroewatch/helper/route_helper.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/app_constants.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:enviroewatch/view/screens/auth/login_screen.dart';
import 'package:enviroewatch/view/screens/menu/menu_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        print('-----------------${isNotConnected ? 'Not' : 'Yes'}');
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no connection' : 'connected',
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    } as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;

    _route();
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
    print('${Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .getUserToken()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(Images.app_logo, width: 150)),
            SizedBox(height: 20),
            Text(AppConstants.APP_NAME,
                style: poppinsBold.copyWith(
                    fontSize: 30, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
