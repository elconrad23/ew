import 'dart:io';

import 'package:enviroewatch/view/screens/menu/menu_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:enviroewatch/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, dynamic selectNotificationStream, dynamic notificationTapBackground) async {
    var androidInitialize =
        new AndroidInitializationSettings('notification_icon');
    var iOSInitialize = DarwinInitializationSettings();
    var initializationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: selectNotificationStream.add,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "onMessage: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
      showNotification(message, flutterLocalNotificationsPlugin, false);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "onOpenApp: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
      try {
        if (message.notification!.titleLocKey != null &&
            message.notification!.titleLocKey!.isNotEmpty) {
          MyApp.navigatorKey.currentState!
              .push(MaterialPageRoute(builder: (context) => MenuScreen()));
        }
      } catch (e) {}
    });
  }

  static Future<void> showNotification(RemoteMessage message,
    FlutterLocalNotificationsPlugin fln, bool data) async {
    String? _title;
    String? _body;
    String? _image;
    if (data) {
      _title = message.data['title'];
      _body = message.data['body'];
    } else {
      _title = message.notification!.title;
      _body = message.notification!.body;

      if (Platform.isAndroid) {
        _image = message.notification!.android!.imageUrl;
      } else if (Platform.isIOS) {
        _image = message.notification!.apple!.imageUrl;
      }
    }

    if (_image != null && _image.isNotEmpty) {
      try {
        await showBigPictureNotificationHiddenLargeIcon(_title!, _body!, fln);
      } catch (e) {
        await showBigTextNotification(_title!, _body!, fln);
      }
    } else {
      await showBigTextNotification(_title!, _body!, fln);
    }
  }

  static Future<void> showTextNotification(
      String title, String body, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> showBigTextNotification(
    String title, String body, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      String title, String body, FlutterLocalNotificationsPlugin fln) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      priority: Priority.max,
      playSound: true,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics);
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      "onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
}
