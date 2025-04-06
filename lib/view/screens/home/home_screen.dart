import 'package:enviroewatch/provider/report_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/utill/images.dart';
import 'package:enviroewatch/view/screens/home/capturescreen.dart';
import 'package:enviroewatch/view/screens/home/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/profile_provider.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool _isLoggedIn;
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    // _determinePosition();
    _getUserLocation();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      Provider.of<ReportProvider>(context, listen: false)
          .getreportList(context);
    } else {}
  }

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
    print("address.locality");
    print(address.street);
    print(address.subLocality);
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: MyDrawer(
          key: Key("reports_screen.dart"),
        ),
        body: WillPopScope(
            onWillPop: () async {
              // Show a dialog asking for confirmation before exiting
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      width: 300,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(height: 20),
                        Icon(Icons.error_outline,
                            size: 50,
                            color: ColorResources.getSecondaryColor(context)),
                        Padding(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                          child: Text('Are you sure you want to Exit ?',
                              style: poppinsRegular,
                              textAlign: TextAlign.center),
                        ),
                        Divider(
                            height: 0,
                            color: ColorResources.getHintColor(context)),
                        Row(children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5))),
                              child: Text('yes',
                                  style: poppinsRegular.copyWith(
                                      color: ColorResources.getSecondaryColor(
                                          context))),
                            ),
                          )),
                          Expanded(
                              child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color:
                                      ColorResources.getSecondaryColor(context),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5))),
                              child: Text('No',
                                  style: poppinsRegular.copyWith(
                                      color: Colors.white)),
                            ),
                          )),
                        ])
                      ]),
                    )),
              ) ?? false;

              // Return the result of the dialog to decide if we should pop the screen
              return shouldExit;
            },
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                leading: Builder(
                  builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(
                        Icons.short_text_rounded,
                        color: Colors.black,
                      )),
                ),
                title: Text(
                  'Enviroewatch',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                pinned: true,
                centerTitle: true,
                actions: [
                  //  IconButton(
                  //     icon: Image.asset(Images.bell,
                  //         color: Theme.of(context).textTheme.bodyText1.color,
                  //         width: 25),
                  //     onPressed: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (_) => NotificationScreen()));
                  //     }),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Consumer<ProfileProvider>(
                        builder: (context, profileProvider, child) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
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
                                            left: Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    profileProvider
                                                                .userInfoModel !=
                                                            null
                                                        ? 'Good day ${profileProvider.userInfoModel.username}!'
                                                        : 'Good day',
                                                    style: poppinsBold.copyWith(
                                                        fontSize: 14,
                                                        color: Colors.white)),
                                                SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          'Have some area to report ?',
                                                          maxLines: 4,
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: poppinsRegular
                                                              .copyWith(
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
                            )),
                    address != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Current location',
                                      style: poppinsBold.copyWith(
                                          fontSize: 14,
                                          color: ColorResources.getTextColor(
                                              context))),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                            '${address.subLocality},${address.locality}',
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                                color:
                                                    ColorResources.getHintColor(
                                                        context))),
                                      ),
                                    ],
                                  ),
                                ]),
                          )
                    : SizedBox(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        padding:
                            EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                        margin: EdgeInsets.only(
                            bottom: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                    ColorResources.getSecondaryColor(context),
                                width: 1)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('About Enviroewatch',
                                  style: poppinsBold.copyWith(
                                      fontSize: 14,
                                      color: ColorResources.getTextColor(
                                          context))),
                              SizedBox(height: 2),
                              Consumer<SplashProvider>(
                                builder: (context, config, child) => Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                          Provider.of<SplashProvider>(
                                                  context,
                                                  listen: false)
                                              .configModel!
                                              .aboutUs,
                                          style: poppinsRegular.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_SMALL,
                                              color: ColorResources
                                                  .getHintColor(
                                                      context))),
                                    ),
                                  ],
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CaptureScreen(
                                                  key: Key("capturescreen.dart"),
                                                )),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          ColorResources.getSecondaryColor(
                                              context),
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width *
                                              .3,
                                          20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: Text('Capture',
                                        style: poppinsRegular.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT)),
                                  ),
                                ],
                              )
                            ]),
                      ),
                    )
                  ],
                ),
              )
            ])));
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
