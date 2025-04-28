import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/profile_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:enviroewatch/view/base/custom_app_bar.dart';
import 'package:enviroewatch/view/base/not_login_screen.dart';
import 'package:enviroewatch/view/screens/profile/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        title: 'Profile',
        isCenter: true,
        isElevation: false,
        onBackPressed: () {
          Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
          child: _isLoggedIn
              ? Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Center(
                          child: SizedBox(
                            width: 1170,
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    ColorResources.getGreyColor(
                                                        context),
                                                width: 2),
                                            shape: BoxShape.circle),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: profileProvider.file == null
                                              ? FadeInImage.assetNetwork(
                                                  placeholder:
                                                      Images.placeholder,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  image:
                                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.userImageUrl}/${profileProvider.userInfoModel?.photo}',
                                                  imageErrorBuilder:
                                                      (c, o, s) => Image.asset(
                                                          Images.placeholder,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover))
                                              : Image.file(profileProvider.file,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fill),
                                        )),
                                    Positioned(
                                      right: -10,
                                      child: TextButton(
                                        onPressed: () {
                                          if (profileProvider.userInfoModel !=
                                              null) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileEditScreen(
                                                            userInfoModel:
                                                                profileProvider.userInfoModel!)));
                                          }
                                        },
                                        child: Text(
                                          'Edit',
                                          style: poppinsMedium.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // for name
                                Center(
                                    child: Text(
                                  '${profileProvider.userInfoModel?.username}',
                                  style: poppinsMedium.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE),
                                )),
                                SizedBox(height: 10),
                                Center(
                                    child: Text(
                                  '${profileProvider.userInfoModel?.phone}',
                                  style: poppinsRegular.copyWith(
                                      color:
                                          ColorResources.getHintColor(context),
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : NotLoggedInScreen()),
    );
  }
}
