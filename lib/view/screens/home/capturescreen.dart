import 'dart:io';

import 'package:enviroewatch/data/model/body/report_body.dart';
import 'package:enviroewatch/data/model/response/response_model.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/report_provider.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/view/base/custom_app_bar.dart';
import 'package:enviroewatch/view/base/custom_button.dart';
import 'package:enviroewatch/view/base/custom_snackbar.dart';
import 'package:enviroewatch/view/screens/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({required Key key}) : super(key: key);

  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  var _results;
  late File _image;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    loadModel().then((value) {
      setState(() {
      });
    });
    print(
        '${Provider.of<AuthProvider>(context, listen: false).getUserToken()}');
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  // get the highest
  int resultCompare(u1, u2) => u2['label'] - u1['label'];

  classifyImage(File image) async {
    List? output = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true);
    var list =
        output?.reduce((a, b) => a['confidence'] > b['confidence'] ? a : b);
    setState(() {
      _results = list;
    });
    print(output);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  final picker = ImagePicker();

  pickCameraImage() async {
    final xFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (xFile != null) {
        _image = File(xFile.path);
        setState(() {
        });
        classifyImage(_image);
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }

  pickGalleryImage() async {
    final xFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (xFile != null) {
        _image = File(xFile.path);
        setState(() {
        });
        classifyImage(_image);
        print('==+++======');
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  // location
  late LatLng currentPostion;
  Placemark address = Placemark();

  void _getUserLocation() async {
    try {
      var position = await GeolocatorPlatform.instance.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      address = placemarks.first;
      setState(() {
        currentPostion = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (e is PermissionDeniedException) {
        debugPrint("Permission Denied");
      }
    }
    print(address.locality);
    print(address.street);
    print(address.subLocality);
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    final now = new DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final format = DateFormat.jm();
    final new_format = format.format(dt);

    return Scaffold(
        key: _scaffoldkey,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(title: _results == null ? 'Upload' : 'Results', onBackPressed: obs),
        body: Scrollbar(
            child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: SizedBox(
              width: 1170,
              child: Consumer<ReportProvider>(
                builder: (context, reportProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Container(
                            child: Image.file(_image,
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0,
                                              horizontal: 20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomButton(
                                                  buttonText: 'Camera',
                                                  onPressed: pickCameraImage),
                                              SizedBox(height: 10.0),
                                              CustomButton(
                                                  buttonText: 'Gallery',
                                                  onPressed:
                                                      pickGalleryImage),
                                              SizedBox(height: 10.0),
                                            ],
                                          )));
                            },
                          ),
                        ],
                      ),
                      _results != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Container(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT + 10),
                                margin: EdgeInsets.only(
                                    bottom: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      ColorResources.getSecondaryColor(context),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          _results.length > 1
                                              ? Text(
                                                  '${_results["label"].split(" ").sublist(1).join(' ')}',
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: Colors.white))
                                              : Text(
                                                  _results["label"]
                                                      .split(" ")
                                                      .sublist(1)
                                                      .join(' '),
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
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
                                          _results["label"]
                                                      .split(" ")
                                                      .sublist(1)
                                                      .join(' ')
                                                      .toString() !=
                                                  'Invalid Photo'
                                              ? _results["confidence"] * 100 <
                                                      26.0
                                                  ? Text('Low',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: Colors.white))
                                                  : _results["confidence"] * 100 >
                                                              25.0 &&
                                                          _results["confidence"] * 100 <
                                                              51.0
                                                      ? Text('Average',
                                                          style: poppinsRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .FONT_SIZE_SMALL,
                                                              color:
                                                                  Colors.white))
                                                      : _results["confidence"] * 100 >
                                                                  50.0 &&
                                                              _results["confidence"] * 100 < 76.0
                                                          ? Text('Moderate', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white))
                                                          : Text('High', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white))
                                              : Text('Invalid', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white))
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
                                          _results["label"]
                                                      .split(" ")
                                                      .sublist(1)
                                                      .join(' ')
                                                      .toString() !=
                                                  'Invalid Photo'
                                              ? _results["confidence"] * 100 <
                                                      26.0
                                                  ? Text(
                                                      'Early sign of declining',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: Colors.white))
                                                  : _results["confidence"] * 100 > 25.0 &&
                                                          _results["confidence"] * 100 <
                                                              51.0
                                                      ? Text('Average',
                                                          style: poppinsRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .FONT_SIZE_SMALL,
                                                              color:
                                                                  Colors.white))
                                                      : _results["confidence"] * 100 >
                                                                  50.0 &&
                                                              _results["confidence"] * 100 < 76.0
                                                          ? Text('Declining', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white))
                                                          : Text('Declining', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white))
                                              : Text('Invalid', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white))
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
                                          _results["label"]
                                                      .split(" ")
                                                      .sublist(1)
                                                      .join(' ')
                                                      .toString() !=
                                                  'Invalid Photo'
                                              ? Text(
                                                  '${(_results["confidence"] * 100).toStringAsFixed(2)}%',
                                                  style: poppinsRegular
                                                      .copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: Colors.white))
                                              : Text('Invalid',
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
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
                                          Text(
                                              '${address.subLocality},${address.locality}',
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL,
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
                                          Text(new_format.toString(),
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ]),
                              ))
                          : SizedBox(),
                      _results == null
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * .2,
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                      _results == null
                          ? InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20.0,
                                                horizontal: 20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomButton(
                                                    buttonText: 'Camera',
                                                    onPressed: pickCameraImage),
                                                SizedBox(height: 10.0),
                                                CustomButton(
                                                    buttonText: 'Gallery',
                                                    onPressed:
                                                        pickGalleryImage),
                                                SizedBox(height: 10.0),
                                              ],
                                            )));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Images.info,
                                          scale: 20,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text('Tap here to capture!',
                                                      style:
                                                          poppinsBold.copyWith(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .white)),
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                            'You can either upload from gallery or capture using camera.',
                                                            maxLines: 4,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: poppinsRegular.copyWith(
                                                                fontSize: Dimensions
                                                                    .FONT_SIZE_SMALL,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          : !reportProvider.isLoading
                              ? InkWell(
                                  onTap: () async {
                                    String _class = _results["label"]
                                            .split(" ")
                                            .sublist(1)
                                            .join(' ')
                                            .toString();
                                    String _degradation =
                                        _results["confidence"] * 100 < 26.0
                                            ? 'Low'
                                            : _results["confidence"] * 100 >
                                                        25.0 &&
                                                    _results["confidence"] *
                                                            100 <
                                                        51.0
                                                ? 'Average'
                                                : _results["confidence"] * 100 >
                                                            50.0 &&
                                                        _results["confidence"] *
                                                                100 <
                                                            76.0
                                                    ? 'Moderate'
                                                    : 'High';

                                    String _prod = _results["confidence"] *
                                                100 <
                                            26.0
                                        ? 'Early sign of declining'
                                        : _results["confidence"] * 100 > 25.0 &&
                                                _results["confidence"] * 100 <
                                                    51.0
                                            ? 'Average'
                                            : _results["confidence"] * 100 >
                                                        50.0 &&
                                                    _results["confidence"] *
                                                            100 <
                                                        76.0
                                                ? 'Declining'
                                                : 'Declining';
                                    String _location =
                                        address.subLocality ?? '';
                                    String _accuracy =
                                        (_results["confidence"] * 100)
                                                .toStringAsFixed(2) ??
                                            '';
                                    String _lat =
                                        currentPostion.latitude.toString();
                                    String _long =
                                        currentPostion.longitude.toString();
                                    String _time = new_format.toString();

                                    ReportBody report = ReportBody(
                                        resultclass: _class,
                                        degradation: _degradation,
                                        productivity: _prod,
                                        accuracy: _accuracy,
                                        place: _location,
                                        lat: _lat,
                                        lon: _long,
                                        // userId: _userid,
                                        timeOfCapture: _time, imagePath: '');

                                    if (_results["label"]
                                            .split(" ")
                                            .sublist(1)
                                            .join(' ')
                                            .toString() !=
                                        'Invalid Photo') {
                                      ResponseModel _responseModel =
                                          await reportProvider.senddata(
                                        report,
                                        _image,
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .getUserToken(),
                                      );
                                      if (_responseModel.isSuccess) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Your results have been submitted successfully'),
                                          backgroundColor: Colors.green,
                                        ));
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => MenuScreen()));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(_responseModel.message),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                      setState(() {});
                                    } else {
                                      showCustomSnackBar(
                                          "Upload or take a valide photo",
                                          context,
                                          isError: true);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_DEFAULT + 10),
                                      margin: EdgeInsets.only(
                                          bottom:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                      ),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              Images.upload,
                                              scale: 20,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                ),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text('Upload',
                                                          style: poppinsBold
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white)),
                                                      SizedBox(height: 2),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                                'Tap here to submit to the support team for recommendation',
                                                                maxLines: 4,
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: poppinsRegular.copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .FONT_SIZE_SMALL,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                )),
                    ]),
              ),
            ),
          ),
        )));
  }
}
