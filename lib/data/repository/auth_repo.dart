import 'dart:async';

import 'package:dio/dio.dart';
import 'package:enviroewatch/data/datasource/remote/dio/dio_client.dart';
import 'package:enviroewatch/data/datasource/remote/exception/api_error_handler.dart';
import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/data/model/response/signup_model.dart';
import 'package:enviroewatch/helper/responsive_helper.dart';
import 'package:enviroewatch/utill/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> registration(SignUpModel signUpModel) async {
    try {
      Response response = await dioClient.post(
        AppConstants.REGISTER_URI,
        data: signUpModel.toJson(), queryParameters: {}, 
        options: Options(), 
        cancelToken: CancelToken(), 
        onSendProgress: (int count, int total) {  }, onReceiveProgress: (int count, int total) {  },
        
      );
      print(signUpModel.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
       print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({required String username, required String password}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOGIN_URI,
        data: {"username": username, "password": password}, queryParameters: {}, 
        options: Options(), 
        cancelToken: CancelToken(), 
        onSendProgress: (int count, int total) {  }, 
        onReceiveProgress: (int count, int total) {  },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for forgot password
  Future<ApiResponse> forgetPassword(String email) async {
    try {
      Response response = await dioClient.post(AppConstants.FORGET_PASSWORD_URI, data: {"email_or_phone": email}, queryParameters: {}, options: Options(), cancelToken: CancelToken(), onSendProgress: (int count, int total) {  }, onReceiveProgress: (int count, int total) {  });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(String mail, String resetToken, String password, String confirmPassword) async {
    try {
      print({"_method": "put", "reset_token": resetToken, "password": password, "confirm_password": confirmPassword, "email_or_phone": mail, "email": mail});
      Response response = await dioClient.post(
        AppConstants.RESET_PASSWORD_URI,
        data: {"_method": "put", "reset_token": resetToken, "password": password, "confirm_password": confirmPassword, "email_or_phone": mail, "email": mail}, queryParameters: {}, options: Options(), cancelToken: CancelToken(), onSendProgress: (int count, int total) {  }, onReceiveProgress: (int count, int total) {  },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify phone number
  Future<ApiResponse> checkEmail(String email) async {
    try {
      Response response = await dioClient.post(AppConstants.CHECK_EMAIL_URI, data: {"email": email}, queryParameters: {}, options: Options(), cancelToken: CancelToken(), onSendProgress: (int count, int total) {  }, onReceiveProgress: (int count, int total) {  });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    try {
      Response response = await dioClient.post(AppConstants.VERIFY_EMAIL_URI, data: {"email": email, "token": token}, queryParameters: {}, options: Options(), cancelToken: CancelToken(), onSendProgress: (int count, int total) {  }, onReceiveProgress: (int count, int total) {  });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

    Future<ApiResponse> verifyToken(String email, String token) async {
    try {
      print({"email": email, "reset_token": token});
      Response response = await dioClient.post(AppConstants.VERIFY_TOKEN_URI, data: {"email": email, "email_or_phone": email, "reset_token": token}, queryParameters: {}, options: Options(), cancelToken: CancelToken(), onSendProgress: (int count, int total) {  }, onReceiveProgress: (int count, int total) {  });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

   Future<ApiResponse> updateToken() async {
    try {
      String? _deviceToken = '';
      if(ResponsiveHelper.isMobilePhone()) {
        _deviceToken = await _saveDeviceToken();
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      }
      Response response = await dioClient.post(
        AppConstants.TOKEN_URI,
        data: {"_method": "put", "cm_firebase_token": _deviceToken}, queryParameters: {}, options: Options(), cancelToken: CancelToken(), onSendProgress: (int count, int total) {  }, onReceiveProgress: (int count, int total) {  },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

   

   Future<String?> _saveDeviceToken() async {
    String? _deviceToken = await FirebaseMessaging.instance.getToken();
    if (_deviceToken != null) {
      print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken;
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }
Future<bool> clearSharedData() async {
   
    await sharedPreferences.remove(AppConstants.TOKEN);
    return true;
  }
  
  // for  Remember 
  Future<void> saveUserNumberAndPassword(String username, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NAME, username);
    } catch (e) {
      throw e;
    }
  }

  String getUserName() {
    return sharedPreferences.getString(AppConstants.USER_NAME) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_NAME);
  }
}
