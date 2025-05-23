
// import 'package:enviroewatch/data/model/response/notification_model.dart';
// import 'package:flutter/material.dart';

// class NotificationDialog extends StatelessWidget {
//   final NotificationModel notificationModel;
//   NotificationDialog({@required this.notificationModel});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL))),
//       insetPadding: EdgeInsets.all(30),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       child: SizedBox(
//         // width: 600,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ),
//               (notificationModel.data.image != null &&
//                       notificationModel.data.image.isNotEmpty)
//                   ? Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.symmetric(
//                           horizontal: Dimensions.PADDING_SIZE_LARGE),
//                       decoration: BoxDecoration(
//                           borderRadius:
//                               BorderRadius.circular(Dimensions.RADIUS_SMALL),
//                           color:
//                               Theme.of(context).primaryColor.withOpacity(0.20)),
//                       child: ClipRRect(
//                         borderRadius:
//                             BorderRadius.circular(Dimensions.RADIUS_SMALL),
//                         child: CustomImage(
//                           isNotification: true,
//                           image:
//                               '${Get.find<SplashController>().configModel.baseUrls.notificationImageUrl}/${notificationModel.data.image}',
//                           width: MediaQuery.of(context).size.width,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     )
//                   : SizedBox(),
//               SizedBox(
//                   height: (notificationModel.data.image != null &&
//                           notificationModel.data.image.isNotEmpty)
//                       ? Dimensions.PADDING_SIZE_LARGE
//                       : 0),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: Dimensions.PADDING_SIZE_LARGE),
//                 child: Text(
//                   notificationModel.data.title,
//                   textAlign: TextAlign.center,
//                   style: robotoMedium.copyWith(
//                     color: Theme.of(context).primaryColor,
//                     fontSize: Dimensions.fontSizeLarge,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
//                 child: Text(
//                   notificationModel.data.description,
//                   textAlign: TextAlign.start,
//                   style: robotoRegular.copyWith(
//                     color: Theme.of(context).disabledColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
