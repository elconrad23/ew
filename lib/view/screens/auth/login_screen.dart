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
import 'create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _usernameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    _usernameController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserNumber();
    _passwordController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Form(
                    key: _formKeyLogin,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //  physics: BouncingScrollPhysics(),
                      children: [
                        //SizedBox(height: 30),
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
                          'Welcome Back',
                          style: poppinsBold.copyWith(
                              fontSize: 26,
                              color: ColorResources.getTextColor(context)),
                        )),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Center(
                          child: Text(
                            'Login to continue',
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color: ColorResources.getHintColor(context)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        CustomTextField(
                          hintText: 'Username',
                          focusNode: _usernameFocus,
                          nextFocus: _passwordFocus,
                          controller: _usernameController,
                          inputType: TextInputType.text,
                            fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {}, 
                                    onSuffixTap: () {},
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        CustomTextField(
                          hintText: 'Password',
                          isPassword: true,
                          isShowSuffixIcon: true,
                          focusNode: _passwordFocus,
                          controller: _passwordController,
                          inputAction: TextInputAction.done,
                          onSuffixTap: () {},
                            fillColor: Colors.white,
                                    onSubmit: (value) {}, // Handle submission
                                    onTap: () {}, // Handle tap event
                                    suffixIconUrl: Icons.person,
                                    prefixIconUrl: Icons.account_circle, 
                                    onChanged: (value) {},
                                    nextFocus: _passwordFocus,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        // for forgot password
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            authProvider.loginErrorMessage.length > 0
                                ? CircleAvatar(
                                    backgroundColor: Colors.red, radius: 5)
                                : SizedBox.shrink(),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.loginErrorMessage,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: Colors.red,
                                    ),
                              ),
                            )
                          ],
                        ),
                       
                        SizedBox(height: 10),
                        // for login button
                        !authProvider.isLoading
                            ? CustomButton(
                                buttonText: 'login',
                                onPressed: () async {
                                  if (_usernameController.text.trim().isEmpty) {
                                    showCustomSnackBar(
                                        'Enter username', context);
                                  } else if (_passwordController.text
                                      .trim()
                                      .isEmpty) {
                                    showCustomSnackBar(
                                        'Enter password', context);
                                  } else if (_passwordController.text
                                          .trim()
                                          .length <
                                      6) {
                                    showCustomSnackBar(
                                        'Password must be greater than 6',
                                        context);
                                  } else {
                                    authProvider
                                        .login(_usernameController.text.trim(),
                                            _passwordController.text.trim())
                                        .then((status) async {
                                      if (status.isSuccess) {
                                        if (authProvider.isActiveRememberMe) {
                                          authProvider
                                              .saveUserUserNameAndPassword(
                                                  _usernameController.text
                                                      .trim(),
                                                  _passwordController.text
                                                      .trim());
                                        } else {
                                          authProvider
                                              .clearUserNameAndPassword();
                                        }
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                RouteHelper.menu,
                                                arguments: MenuScreen());
                                      }
                                    });
                                  }
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              )),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                                RouteHelper.createAccount,
                                arguments: CreateAccountScreen());
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an Account ?',
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color:
                                          ColorResources.getHintColor(context)),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Text(
                                  'Sign Up',
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
      ),
    );
  }
}
