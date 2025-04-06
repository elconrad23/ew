import 'dart:io';

import 'package:flutter/material.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final bool isCenter;
  final bool isElevation;
  CustomAppBar({required this.title, this.isBackButtonExist = true, required this.onBackPressed, this.isCenter=true,this.isElevation=false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
      centerTitle: isCenter?true:false,
      leading: isBackButtonExist ? IconButton(
        icon: Icon( !Platform.isIOS ? Icons.arrow_back : Icons.arrow_back_ios),
        color: ColorResources.getSecondaryColor(context),
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : SizedBox(),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      elevation: isElevation?2:0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
