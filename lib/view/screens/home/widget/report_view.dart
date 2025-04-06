import 'dart:io';

import 'package:enviroewatch/data/model/response/report_model.dart';
import 'package:enviroewatch/provider/report_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/view/screens/home/capturescreen.dart';
import 'package:flutter/material.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

class ReportView extends StatelessWidget {
  Future<void> _loadData(BuildContext context) async {
    await Provider.of<ReportProvider>(context, listen: false)
        .getreportList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        Consumer<ReportProvider>(builder: (context, reportProvider, child) {
      late List<ReportsModel> reportlist;
      reportlist = reportProvider.historyList.reversed.toList();
    
      return reportlist != null
          ? reportlist.length > 0
              ? RefreshIndicator(
                  onRefresh: () async {
                    await _loadData(context);
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    itemCount: reportlist.length,
                    itemBuilder: (context, index) {
                      print('=============');
                      print(reportlist);
                      print('===============');
                      return InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => GalleryView(
                          //             image:
                          //                 '${Provider.of<SplashProvider>(context, listen: false).baseUrls.reportImageUrl}/${reportlist != null ? reportlist[index].details.imagePath : ''}')));

                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.only(
                                topEnd: Radius.circular(25),
                                topStart: Radius.circular(25),
                              ),
                            ),
                            builder: (context) => SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.reportImageUrl}/${reportlist != null ? reportlist[index].details.imagePath : ''}',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholder,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Divider(),
                                            SizedBox(height: 2),
                                            reportlist[index].reportcomment !=
                                                    null
                                                ? Text('Recomendation',
                                                    style: poppinsSemiBold
                                                        .copyWith(
                                                            fontSize: 14,
                                                            color: ColorResources
                                                                .getTextColor(
                                                                    context)))
                                                : SizedBox(),
                                            reportlist[index].reportcomment !=
                                                    null
                                                ? Text(
                                                    '${reportlist[index].reportcomment}',
                                                    style: poppinsLight.copyWith(
                                                        fontSize: 14,
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context)))
                                                : SizedBox()
                                          ]),
                                    ),
                                    SizedBox(
                                      height:
                                          Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Container(
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            margin: EdgeInsets.only(
                                bottom: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300] ?? Colors.grey,
                                    blurRadius: 2,
                                    spreadRadius: 1)
                              ],
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Class',
                                                    style:
                                                        poppinsMedium.copyWith(
                                                            fontSize: 14,
                                                            color: ColorResources
                                                                .getTextColor(
                                                                    context))),
                                                Text(
                                                    '${reportlist[index].details.resultclass}',
                                                    style: poppinsLight.copyWith(
                                                        fontSize: 14,
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context))),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Degradation',
                                                    style:
                                                        poppinsMedium.copyWith(
                                                            fontSize: 14,
                                                            color: ColorResources
                                                                .getTextColor(
                                                                    context))),
                                                Text(
                                                    '${reportlist[index].details.degradation}',
                                                    style: poppinsLight.copyWith(
                                                        fontSize: 14,
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context))),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Productivity',
                                                    style:
                                                        poppinsMedium.copyWith(
                                                            fontSize: 14,
                                                            color: ColorResources
                                                                .getTextColor(
                                                                    context))),
                                                Text(
                                                    '${reportlist[index].details.productivity}',
                                                    style: poppinsLight.copyWith(
                                                        fontSize: 14,
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context))),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Accuracy',
                                                    style:
                                                        poppinsMedium.copyWith(
                                                            fontSize: 14,
                                                            color: ColorResources
                                                                .getTextColor(
                                                                    context))),
                                                Text(
                                                    '${reportlist[index].details.accuracy}',
                                                    style: poppinsLight.copyWith(
                                                        fontSize: 14,
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context))),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Location',
                                                    style:
                                                        poppinsMedium.copyWith(
                                                            fontSize: 14,
                                                            color: ColorResources
                                                                .getTextColor(
                                                                    context))),
                                                Text(
                                                    '${reportlist[index].details.place}',
                                                    style: poppinsLight.copyWith(
                                                        fontSize: 14,
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context))),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Time',
                                                    style:
                                                        poppinsMedium.copyWith(
                                                            fontSize: 14,
                                                            color: ColorResources
                                                                .getTextColor(
                                                                    context))),
                                                Text(
                                                    '${reportlist[index].details.timeOfCapture}',
                                                    style: poppinsLight.copyWith(
                                                        fontSize: 14,
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context))),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: reportlist[index]
                                                                  .reportcomment ==
                                                              null
                                                          ? Colors.amber
                                                          : ColorResources
                                                              .getSecondaryColor(
                                                                  context),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          reportlist[index]
                                                                      .reportcomment ==
                                                                  null
                                                              ? 'Pending recommendation'
                                                              : 'View recommendation',
                                                          style: poppinsMedium
                                                              .copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_EXTRA_SMALL,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ]),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .2),
                        Image.asset(
                          Images.empty,
                          scale: 8,
                        ),
                        Container(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('No submissions, yet!',
                              textAlign: TextAlign.center,
                              style: poppinsBold.copyWith(
                                  fontSize: 14, color: Colors.black)),
                        ),
                        Container(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                              'No submissions made yet! Start reporting now',
                              textAlign: TextAlign.center,
                              style: poppinsRegular.copyWith(
                                  fontSize: 12,
                                  color: ColorResources.getHintColor(context))),
                        ),
                        Container(height: 25),
                        Container(
                          width: 180,
                          height: 40,
                          child: TextButton(
                            child: Text('Take a pic',
                                style: poppinsBold.copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.secondary)),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  ColorResources.getSecondaryColor(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CaptureScreen(key: Key("capture_screen.dart"),)));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
          : Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor)));
    }));
  }
}

class GalleryView extends StatelessWidget {
  final String image;

  const GalleryView({required Key key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PhotoView(
            imageProvider: NetworkImage(
          '$image',
        )),
        Positioned(
            left: 16,
            top: Platform.isIOS ? 60 : 40,
            child: GestureDetector(
              child: Container(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.clear, color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            )),
      ],
    );
  }
}
