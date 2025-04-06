import 'package:enviroewatch/helper/responsive_helper.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MenuButton extends StatelessWidget {
  final int index;
  final String icon;
  final String title;
  MenuButton({
      required this.index,
      required this.icon,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return ListTile(
          onTap: () {
            ResponsiveHelper.isMobilePhone()
                ? splash.setPageIndex(index)
                : SizedBox();
            
          },
          selected: splash.pageIndex == index,
          leading: Image.asset(
            icon,
            color:  ColorResources.getSecondaryColor(context),
            width: 25,
            height: 25,
          ),
          title: Text(title,
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: ColorResources.getSecondaryColor(context),
              )),
        );
      },
    );
  }
}
