
// import 'package:enviroewatch/helper/route_helper.dart';
// import 'package:enviroewatch/view/base/custom_app_bar.dart';
// import 'package:enviroewatch/view/base/no_data_screen.dart';
// import 'package:enviroewatch/view/screens/notification/widget/notification_dialog.dart';
// import 'package:flutter/material.dart';

// import '../../../utill/color_resources.dart';
// import '../../../utill/dimensions.dart';
// import '../../../utill/styles.dart';

// class NotificationScreen extends StatefulWidget {
//   final bool fromNotification;
//   const NotificationScreen({this.fromNotification = false});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   void _loadData() async {
   
//   }

//   @override
//   void initState() {
//     super.initState();

//     _loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//          onWillPop: () async => showDialog(
//                   context: context,
//                   builder: (context) => Dialog(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5)),
//                       child: Container(
//                         width: 300,
//                         child:
//                             Column(mainAxisSize: MainAxisSize.min, children: [
//                           SizedBox(height: 20),
//                           Icon(Icons.error_outline,
//                               size: 50,
//                               color: ColorResources.getSecondaryColor(context)),
//                           Padding(
//                             padding:
//                                 EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//                             child: Text('Are you sure you want to Exit ?',
//                                 style: poppinsRegular,
//                                 textAlign: TextAlign.center),
//                           ),
//                           Divider(
//                               height: 0,
//                               color: ColorResources.getHintColor(context)),
//                           Row(children: [
//                             Expanded(
//                                 child: InkWell(
//                               onTap: () {
//                                 Navigator.of(context).pop(true);
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(
//                                     Dimensions.PADDING_SIZE_SMALL),
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(5))),
//                                 child: Text('yes',
//                                     style: poppinsRegular.copyWith(
//                                         color: ColorResources.getSecondaryColor(
//                                             context))),
//                               ),
//                             )),
//                             Expanded(
//                                 child: InkWell(
//                               onTap: () => Navigator.pop(context),
//                               child: Container(
//                                 padding: EdgeInsets.all(
//                                     Dimensions.PADDING_SIZE_SMALL),
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     color: ColorResources.getSecondaryColor(
//                                         context),
//                                     borderRadius: BorderRadius.only(
//                                         bottomRight: Radius.circular(5))),
//                                 child: Text('No',
//                                     style: poppinsRegular.copyWith(
//                                         color: Colors.white)),
//                               ),
//                             )),
//                           ])
//                         ]),
//                       )),
//                 ),
           
//       child: Scaffold(
//         appBar: CustomAppBar(
//             title: 'Notifications',
//             onBackPressed: () {
             
//             }),
//         body:  GetBuilder<NotificationController>(
//                 builder: (notificationController) {
//                 if (notificationController.notificationList != null) {
//                   notificationController.saveSeenNotificationCount(
//                       notificationController.notificationList.length);
//                 }
//                 List<DateTime> _dateTimeList = [];
//                 return notificationController.notificationList != null
//                     ? notificationController.notificationList.length > 0
//                         ? RefreshIndicator(
//                             onRefresh: () async {
//                               await notificationController
//                                   .getNotificationList(true);
//                             },
//                             child: Scrollbar(
//                                 child: SingleChildScrollView(
//                               physics: AlwaysScrollableScrollPhysics(),
//                               child: FooterView(
//                                 child: SizedBox(
//                                     width: Dimensions.WEB_MAX_WIDTH,
//                                     child: ListView.builder(
//                                       itemCount: notificationController
//                                           .notificationList.length,
//                                       padding: EdgeInsets.all(
//                                           Dimensions.PADDING_SIZE_SMALL),
//                                       physics: NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       itemBuilder: (context, index) {
//                                         DateTime _originalDateTime =
//                                             DateConverter.dateTimeStringToDate(
//                                                 notificationController
//                                                     .notificationList[index]
//                                                     .createdAt);
//                                         DateTime _convertedDate = DateTime(
//                                             _originalDateTime.year,
//                                             _originalDateTime.month,
//                                             _originalDateTime.day);
//                                         bool _addTitle = false;
//                                         if (!_dateTimeList
//                                             .contains(_convertedDate)) {
//                                           _addTitle = true;
//                                           _dateTimeList.add(_convertedDate);
//                                         }
//                                         return Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               _addTitle
//                                                   ? Padding(
//                                                       padding: EdgeInsets.only(
//                                                           bottom: Dimensions
//                                                               .PADDING_SIZE_EXTRA_SMALL),
//                                                       child: Text(DateConverter
//                                                           .dateTimeStringToDateOnly(
//                                                               notificationController
//                                                                   .notificationList[
//                                                                       index]
//                                                                   .createdAt)),
//                                                     )
//                                                   : SizedBox(),
//                                               InkWell(
//                                                 onTap: () {
//                                                   showDialog(
//                                                       context: context,
//                                                       builder: (BuildContext
//                                                           context) {
//                                                         return NotificationDialog(
//                                                             notificationModel:
//                                                                 notificationController
//                                                                         .notificationList[
//                                                                     index]);
//                                                       });
//                                                 },
//                                                 child: Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: Dimensions
//                                                           .PADDING_SIZE_EXTRA_SMALL),
//                                                   child: Row(children: [
//                                                     ClipOval(
//                                                         child: CustomImage(
//                                                       isNotification: true,
//                                                       height: 40,
//                                                       width: 40,
//                                                       fit: BoxFit.cover,
//                                                       image:
//                                                           '${Get.find<SplashController>().configModel.baseUrls.notificationImageUrl}'
//                                                           '/${notificationController.notificationList[index].data.image}',
//                                                     )),
//                                                     SizedBox(
//                                                         width: Dimensions
//                                                             .PADDING_SIZE_SMALL),
//                                                     Expanded(
//                                                         child: Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                           Text(
//                                                             notificationController
//                                                                     .notificationList[
//                                                                         index]
//                                                                     .data
//                                                                     .title ??
//                                                                 '',
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: robotoMedium
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         Dimensions
//                                                                             .fontSizeSmall),
//                                                           ),
//                                                           Text(
//                                                             notificationController
//                                                                     .notificationList[
//                                                                         index]
//                                                                     .data
//                                                                     .description ??
//                                                                 '',
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: robotoRegular
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         Dimensions
//                                                                             .fontSizeSmall),
//                                                           ),
//                                                         ])),
//                                                   ]),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     EdgeInsets.only(left: 50),
//                                                 child: Divider(
//                                                     color: Theme.of(context)
//                                                         .disabledColor,
//                                                     thickness: 1),
//                                               ),
//                                             ]);
//                                       },
//                                     )),
//                               ),
//                             )),
//                           )
//                         : NoDataScreen(
//                             text: 'no_notification_found'.tr, showFooter: true)
//                     : Center(child: CircularProgressIndicator());
//               })
//             : NotLoggedInScreen(),
//       ),
//     );
//   }
// }
