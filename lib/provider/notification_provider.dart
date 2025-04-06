import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/data/model/response/notification_model.dart';
import 'package:enviroewatch/data/repository/notification_repo.dart';
import 'package:enviroewatch/helper/api_checker.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo notificationRepo;
  NotificationProvider({required this.notificationRepo});

  late List<NotificationModel> _notificationList;
  List<NotificationModel> get notificationList => _notificationList != null ? _notificationList.reversed.toList() : _notificationList;

  Future<void> initNotificationList(BuildContext context) async {
    ApiResponse apiResponse = await notificationRepo.getNotificationList();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _notificationList = [];
      apiResponse.response?.data.forEach((notificatioModel) => _notificationList.add(NotificationModel.fromJson(notificatioModel)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
}
