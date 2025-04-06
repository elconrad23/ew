import 'package:enviroewatch/data/model/response/signup_model.dart';
import 'package:enviroewatch/helper/route_helper.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:enviroewatch/view/base/custom_button.dart';
import 'package:enviroewatch/view/base/custom_snackbar.dart';
import 'package:enviroewatch/view/base/custom_text_field.dart';
import 'package:enviroewatch/view/screens/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class CreateAccountScreen extends StatelessWidget {
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            Images.app_logo,
                            height: MediaQuery.of(context).size.height / 7.5,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                          child: Text(
                        'Let\'s Get Started!',
                        style: poppinsBold.copyWith(
                            fontSize: 26,
                            color: ColorResources.getTextColor(context)),
                      )),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Center(
                        child: Text(
                          'Create an account',
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: ColorResources.getHintColor(context)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      // for last name section
                      CustomTextField(
                        hintText: 'Username',
                        isShowBorder: true,
                        controller: _usernameController,
                        focusNode: _usernameFocus,
                        nextFocus: _numberFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        onSuffixTap: () {}, 
                        fillColor: Colors.white,
                        onSubmit: (value) {}, // Handle submission
                        onTap: () {}, // Handle tap event
                        suffixIconUrl: Icons.person,
                        prefixIconUrl: Icons.account_circle, 
                        onChanged: (value) {},
                      ),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: 'Phonenumber',
                        isShowBorder: true,
                        controller: _numberController,
                        focusNode: _numberFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.phone,
                        onSuffixTap: () {}, 
                                    fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {},
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // for password section

                      CustomTextField(
                        hintText: 'Password',
                        isShowBorder: true,
                        isPassword: true,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                        onSuffixTap: () {}, 
                                    fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {},
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        hintText: 'Confirm password',
                        isShowBorder: true,
                        isPassword: true,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                        inputAction: TextInputAction.done,
                        onSuffixTap: () {}, 
                                    fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {},
                                    nextFocus: _confirmPasswordFocus,
                      ),

                      SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.registrationErrorMessage.length > 0
                              ? CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.registrationErrorMessage,
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),

                      // for signup button
                      SizedBox(height: 10),
                      !authProvider.isLoading
                          ? CustomButton(
                              buttonText: 'Register',
                              onPressed: () {
                                String _username =
                                    _usernameController.text.trim();
                                String _number = _numberController.text.trim();
                                String _password =
                                    _passwordController.text.trim();
                                String _confirmPassword =
                                    _confirmPasswordController.text.trim();
                                if (_username.isEmpty) {
                                  showCustomSnackBar('Enter username', context);
                                } else if (_number.isEmpty) {
                                  showCustomSnackBar(
                                      'Enter Phone number', context);
                                } else if (_password.isEmpty) {
                                  showCustomSnackBar('Enter password', context);
                                } else if (_password.length < 6) {
                                  showCustomSnackBar(
                                      'Password must be greater than 6',
                                      context);
                                } else if (_confirmPassword.isEmpty) {
                                  showCustomSnackBar(
                                      'Enter confirm password', context);
                                } else if (_password != _confirmPassword) {
                                  showCustomSnackBar(
                                      'Passwords do not match', context);
                                } else {
                                  SignUpModel signUpModel = SignUpModel(
                                    password: _password,
                                    phone: _number,
                                    username: _username,
                                  );
                                  print(signUpModel.toJson());
                                  authProvider
                                      .registration(signUpModel)
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      Navigator.of(context).pushReplacementNamed(RouteHelper.menu,
                arguments: MenuScreen());
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )),

                      // for already an account
                      SizedBox(height: 11),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              RouteHelper.login,
                              arguments: LoginScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color:
                                        ColorResources.getHintColor(context)),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Text(
                                'login',
                                style: poppinsBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.getSecondaryColor(
                                        context)),
                              ),
                            ],
                          ),
                        ),
                      ),
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
