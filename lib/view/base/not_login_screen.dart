import 'package:flutter/material.dart';
import 'package:enviroewatch/helper/route_helper.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:enviroewatch/view/base/custom_button.dart';


class NotLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          Text(
            'GuestMode',
            style: poppinsRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.02),

          Text(
            'You are now in guest mode',
            style: poppinsRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

           CustomButton(buttonText: 'Login', onPressed: () {
             // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              Navigator.pushNamed(context, RouteHelper.login);
            }),
          

        ]),
      ),
    );
  }
}
