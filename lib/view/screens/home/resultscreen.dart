import 'dart:io';

import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/styles.dart';

class ResultScreen extends StatelessWidget {
  final String label;
  final File image;
  final double accuracy;

  const ResultScreen({required Key key, required this.label, required this.image, required this.accuracy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(title: 'Results', onBackPressed: onBackPressed()),
        body: Scrollbar(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          image == null
                              ? Container()
                              : Container(
                                  child: Image.file(image,
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, o, s) => Image.asset(
                                          Images.placeholder,
                                          width: double.infinity,
                                          height: 300,
                                          fit: BoxFit.cover)),
                                ),
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.black),
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                Images.camera,
                                color: Colors.white,
                                scale: 15,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Container(
                            padding: EdgeInsets.all(
                                Dimensions.PADDING_SIZE_DEFAULT + 10),
                            margin: EdgeInsets.only(
                                bottom: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorResources.getSecondaryColor(context),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Class',
                                          style: poppinsBold.copyWith(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text(label,
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Level of Degradation',
                                          style: poppinsBold.copyWith(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text('High',
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Productivity',
                                          style: poppinsBold.copyWith(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text('Declining',
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Accuracy',
                                          style: poppinsBold.copyWith(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text(accuracy.round().toString(),
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Location',
                                          style: poppinsBold.copyWith(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text('Mbarara',
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Time',
                                          style: poppinsBold.copyWith(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text('3:30 PM',
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ]),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: EdgeInsets.all(
                              Dimensions.PADDING_SIZE_DEFAULT + 10),
                          margin: EdgeInsets.only(
                              bottom: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Images.upload,
                                  scale: 20,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('Upload',
                                              style: poppinsBold.copyWith(
                                                  fontSize: 14,
                                                  color: Colors.white)),
                                          SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    'Tap here to submit to the support team for recommendation',
                                                    maxLines: 4,
                                                    softWrap: true,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    style:
                                                        poppinsRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_SMALL,
                                                            color:
                                                                Colors.white)),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }
}

onBackPressed() {
}
