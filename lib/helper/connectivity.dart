import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    ConnectivityResult _result = (await connectivity.checkConnectivity()) as ConnectivityResult;
    return _result != ConnectivityResult.none;
  }

  static void checkConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {

      if (Provider.of<SplashProvider>(context, listen: false).firstTimeConnectionCheck) {
        Provider.of<SplashProvider>(context, listen: false).setFirstTimeConnectionCheck(false);
      } else {
        bool isNotConnected = result == ConnectivityResult.none;
        if (!isNotConnected) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.black: Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no connection' : 'connected',
            textAlign: TextAlign.center,
          ),
        ));
      }
    } as void Function(List<ConnectivityResult> event)?);
  }
}
