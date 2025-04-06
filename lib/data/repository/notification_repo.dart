import 'package:dio/dio.dart';
import 'package:enviroewatch/data/datasource/remote/dio/dio_client.dart';
import 'package:enviroewatch/data/datasource/remote/exception/api_error_handler.dart';
import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/utill/app_constants.dart';

class NotificationRepo {
  final DioClient dioClient;

  NotificationRepo({required this.dioClient});

  Future<ApiResponse> getNotificationList() async {
    try {
      final response = await dioClient.get('${AppConstants.NOTIFICATION_URI}', queryParameters: {}, options: Options(), cancelToken: CancelToken(), onReceiveProgress: (int count, int total) {  });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
