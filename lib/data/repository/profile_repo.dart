import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:enviroewatch/data/datasource/remote/dio/dio_client.dart';
import 'package:enviroewatch/data/datasource/remote/exception/api_error_handler.dart';
import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/data/model/response/userinfo_model.dart';
import 'package:enviroewatch/utill/app_constants.dart';
import 'package:path/path.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileRepo{
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ProfileRepo({required this.dioClient, required this.sharedPreferences});


  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient.get(AppConstants.USER_INFO_URI, queryParameters: {}, options: Options(), cancelToken: CancelToken(), onReceiveProgress: (int count, int total) {  });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel, File file, XFile data, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPDATE_PROFILE_URI}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
      Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      '_method': 'put', 'username': userInfoModel.username, 'phone': userInfoModel.phone
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }


}