import 'package:enviroewatch/data/model/response/response_model.dart';
import 'package:enviroewatch/data/model/response/userinfo_model.dart';
import 'package:enviroewatch/helper/responsive_helper.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/profile_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:enviroewatch/view/base/custom_app_bar.dart';
import 'package:enviroewatch/view/base/custom_snackbar.dart';
import 'package:enviroewatch/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserInfoModel userInfoModel;

  ProfileEditScreen({required this.userInfoModel});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late FocusNode usernameFocus;
  late FocusNode phoneFocus;
  late FocusNode passwordFocus;
  late FocusNode confirmPasswordFocus;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);

    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    usernameFocus = FocusNode();

    phoneFocus = FocusNode();
    passwordFocus = FocusNode();
    confirmPasswordFocus = FocusNode();

    _usernameController.text = widget.userInfoModel.username;
    _phoneController.text = widget.userInfoModel.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(title: 'Update profile', onBackPressed: obs,),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // for profileimage
                      Container(
                        margin: EdgeInsets.only(top: 25, bottom: 24),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorResources.getGreyColor(context),
                              width: 3),
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            if (ResponsiveHelper.isMobilePhone()) {
                              profileProvider.choosePhoto();
                            } else {
                              profileProvider.pickImage();
                            }
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: profileProvider.file != null
                                    ? Image.file(profileProvider.file,
                                        width: 80, height: 80, fit: BoxFit.fill)
                                    : profileProvider.data != null
                                        ? Image.network(
                                            profileProvider.data.path,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.fill)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: FadeInImage.assetNetwork(
                                              placeholder: Images.placeholder,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              image:
                                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.userImageUrl}/${profileProvider.userInfoModel.photo}',
                                              imageErrorBuilder: (c, o, s) =>
                                                  Image.asset(
                                                      Images.placeholder,
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.cover),
                                            ),
                                          ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 0,
                                child: Image.asset(
                                  Images.camera,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      //mobileNumber,username,gender
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // for username section
                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      'username',
                                      style: poppinsRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        color: ColorResources.getHintColor(
                                            context),
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    hintText: 'Enter username',
                                    isElevation: false,
                                    isPadding: false,
                                    controller: _usernameController,
                                    focusNode: usernameFocus,
                                    nextFocus: phoneFocus,
                                    inputType: TextInputType.text,
                                    onSuffixTap: () {}, 
                                    fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 20,
                                  right: 20,
                                  child: Divider()),
                            ],
                          ),
                          SizedBox(height: 15),

                          // for Phone Number section
                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      'phonenumber',
                                      style: poppinsRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        color: ColorResources.getHintColor(
                                            context),
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    hintText: 'Enter phone number',
                                    isElevation: false,
                                    isPadding: false,
                                    controller: _phoneController,
                                    focusNode: phoneFocus,
                                    nextFocus: passwordFocus,
                                    inputType: TextInputType.phone,
                                    onSuffixTap: () {}, 
                                    fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 20,
                                  right: 20,
                                  child: Divider()),
                            ],
                          ),
                          SizedBox(height: 15),

                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      'Password',
                                      style: poppinsRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        color: ColorResources.getHintColor(
                                            context),
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    hintText: 'enter password',
                                    isElevation: false,
                                    isPadding: false,
                                    controller: _passwordController,
                                    focusNode: passwordFocus,
                                    nextFocus: confirmPasswordFocus,
                                    onSuffixTap: () {}, 
                                    fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 20,
                                  right: 20,
                                  child: Divider()),
                            ],
                          ),
                          SizedBox(height: 15),

                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      'Confirm password',
                                      style: poppinsRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        color: ColorResources.getHintColor(
                                            context),
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    hintText: 'Confirm password',
                                    isElevation: false,
                                    isPadding: false,
                                    controller: _confirmPasswordController,
                                    focusNode: confirmPasswordFocus,
                                    inputAction: TextInputAction.done,
                                    onSuffixTap: () {}, 
                                    fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {},
                                    nextFocus: confirmPasswordFocus, //edited with uncertainty
                                  ),
                                ],
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 20,
                                  right: 20,
                                  child: Divider()),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 50),
                      !profileProvider.isLoading
                          ? TextButton(
                              onPressed: () async {
                                String _phoneNumber =
                                    _phoneController.text.trim();
                                String _username =
                                    _usernameController.text.trim();
                                String _password =
                                    _passwordController.text.trim();
                                String _confirmPassword =
                                    _confirmPasswordController.text.trim();
                                if (profileProvider.userInfoModel.phone ==
                                        _phoneNumber &&
                                    profileProvider.userInfoModel.username ==
                                        _usernameController.text &&
                                    profileProvider.file == null &&
                                    profileProvider.data == null &&
                                    _password.isEmpty &&
                                    _confirmPassword.isEmpty) {
                                  showCustomSnackBar(
                                      'Change something to update', context);
                                } else if (_phoneNumber.isEmpty) {
                                  showCustomSnackBar(
                                      'Enter phone number', context);
                                } else if (_username.isEmpty) {
                                  showCustomSnackBar('Enter username', context);
                                } else if ((_password.isNotEmpty &&
                                        _password.length < 6) ||
                                    (_confirmPassword.isNotEmpty &&
                                        _confirmPassword.length < 6)) {
                                  showCustomSnackBar(
                                      'Password should be greater than 6',
                                      context);
                                } else if (_password != _confirmPassword) {
                                  showCustomSnackBar(
                                      'Passwords dont match', context);
                                } else {
                                  UserInfoModel updateUserInfoModel =
                                      profileProvider.userInfoModel;
                                  updateUserInfoModel.phone =
                                      _phoneController.text;
                                  updateUserInfoModel.username =
                                      _usernameController.text;

                                  print(_usernameController.text);
                                  print(profileProvider.country);
                                  ResponseModel _responseModel =
                                      await profileProvider.updateUserInfo(
                                    updateUserInfoModel,
                                    profileProvider.file,
                                    profileProvider.data,
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .getUserToken(),
                                  );

                                  if (_responseModel.isSuccess) {
                                    profileProvider.getUserInfo(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Update was successful'),
                                      backgroundColor: Colors.green,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(_responseModel.message),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                  setState(() {});
                                }
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
