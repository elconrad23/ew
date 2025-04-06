import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:enviroewatch/view/base/custom_button.dart';
import 'package:enviroewatch/view/screens/home/capturescreen.dart';
import 'package:flutter/material.dart';

class NoDataScreen extends StatelessWidget {
  final bool isNothing;
  final bool isProfile;
  NoDataScreen({this.isNothing = false, this.isProfile = false});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: _height * 0.3),
          Image.asset(
            Images.empty,
            width: _height * 0.17,
            height: _height * 0.17,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: _height * 0.03),
          Text(
            'No data to display',
            style: poppinsMedium.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: _height * 0.02),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _height * 0.01),
          SizedBox(
            height: 40,
            width: 150,
            child: CustomButton(
              buttonText: 'Take a photo',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => CaptureScreen(key: Key("capturescreen"),)),
                    (route) => false);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
