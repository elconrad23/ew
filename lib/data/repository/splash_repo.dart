import 'package:dio/dio.dart';
import 'package:enviroewatch/data/datasource/remote/dio/dio_client.dart';
import 'package:enviroewatch/data/datasource/remote/exception/api_error_handler.dart';
import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient.get(
        AppConstants.CONFIG_URI,
        queryParameters: {}, // Provide an empty map if no parameters are needed
        options: Options(), // Default options
        cancelToken: CancelToken(), // Provide a cancel token
        onReceiveProgress: (received, total) {},
      ); // Empty progress callback
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }

    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }
}
