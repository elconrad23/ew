import 'package:enviroewatch/view/screens/menu/widget/custom_drawer.dart';
import 'package:flutter/material.dart';

import 'main_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CustomDrawerController _drawerController = CustomDrawerController();

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      controller: _drawerController,
      mainScreen: MainScreen(drawerController: _drawerController),
      showShadow: false,
      angle: 0.0,
      borderRadius: 30,
      slideWidth: MediaQuery.of(context).size.width *
          (CustomDrawer.isRTL(context) ? 0.45 : 0.70),  
      openCurve: Curves.easeInOut,
      closeCurve: Curves.easeOut,
    );
  }
}

