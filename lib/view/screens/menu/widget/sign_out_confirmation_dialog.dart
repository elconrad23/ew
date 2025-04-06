import 'package:flutter/material.dart';
import 'package:enviroewatch/helper/responsive_helper.dart';
import 'package:enviroewatch/helper/route_helper.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:provider/provider.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Container(
            width: 300,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 20),
              Icon(Icons.error_outline,
                  size: 50, color: ColorResources.getSecondaryColor(context)),
              Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                child: Text('Are you sure you want to sign out?',
                    style: poppinsRegular, textAlign: TextAlign.center),
              ),
              Divider(height: 0, color: ColorResources.getHintColor(context)),
              !auth.isLoading
                  ? Row(children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Provider.of<SplashProvider>(context, listen: false)
                              .setPageIndex(0);
                          Provider.of<AuthProvider>(context, listen: false)
                              .clearSharedData();
                          if (ResponsiveHelper.isWeb()) {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteHelper.getMainRoute(), (route) => false);
                          } else {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteHelper.getLoginRoute(), (route) => false);
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5))),
                          child: Text('Yes',
                              style: poppinsRegular.copyWith(
                                  color: ColorResources.getSecondaryColor(
                                      context))),
                        ),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorResources.getSecondaryColor(context),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5))),
                          child: Text('No',
                              style:
                                  poppinsRegular.copyWith(color: Colors.white)),
                        ),
                      )),
                    ])
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorResources.getSecondaryColor(context)))),
            ]),
          )),
    );
  }
}
