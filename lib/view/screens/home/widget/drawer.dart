import 'package:enviroewatch/helper/route_helper.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/profile_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:enviroewatch/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:enviroewatch/view/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Container(
        width: width * .7,
        child: Drawer(
            child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Container(
                  height: 170.0,
                  decoration: BoxDecoration(color: Colors.black),
                  child: DrawerHeader(
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isLoggedIn
                                  ? Align(
                                      alignment: FractionalOffset.center,
                                      child: ClipOval(
                                          child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.userImageUrl}/${profileProvider.userInfoModel != null ? profileProvider.userInfoModel?.photo : ''}',
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder: (c, o, s) =>
                                            Image.asset(Images.placeholder,
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover),
                                      )))
                                  : Align(
                                      alignment: FractionalOffset.center,
                                      child: ClipOval(
                                        child: Image.asset(Images.placeholder,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover),
                                      )),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  profileProvider.userInfoModel != null
                                      ? '${profileProvider.userInfoModel?.username ?? ''}'
                                      : '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  profileProvider.userInfoModel != null
                                      ? '${profileProvider.userInfoModel?.phone ?? ''}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xAAFFFFFFF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteHelper.getHomeRoute(), (route) => false);
                },
                leading: Image.asset(
                  Images.home,
                  color: ColorResources.getSecondaryColor(context),
                  width: 25,
                  height: 25,
                ),
                title: Text(
                  'Home',
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteHelper.getReportRoute(), (route) => false);
                },
                leading: Image.asset(
                  Images.reports,
                  color: ColorResources.getSecondaryColor(context),
                  width: 25,
                  height: 25,
                ),
                title: Text(
                  'My Reports',
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {
                  if (_isLoggedIn) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => SignOutConfirmationDialog());
                  } else {
                    Provider.of<SplashProvider>(context, listen: false)
                        .setPageIndex(0);

                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteHelper.getLoginRoute(), (route) => false);
                  }
                },
                leading: Image.asset(
                  _isLoggedIn ? Images.logout : Images.app_logo,
                  color: ColorResources.getSecondaryColor(context),
                  width: 25,
                  height: 25,
                ),
                title: Text(
                  _isLoggedIn ? 'log out' : 'login',
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: height * .4,
              ),
              ListTile(
                title: Center(
                    child: Text('Version 1.0',
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: ColorResources.getHintColor(context)))),
              ),
            ],
          ),
        )));
  }
}
