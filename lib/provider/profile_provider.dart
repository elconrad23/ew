import 'dart:convert';
import 'dart:io';

import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/data/model/response/response_model.dart';
import 'package:enviroewatch/data/model/response/userinfo_model.dart';
import 'package:enviroewatch/data/repository/profile_repo.dart';
import 'package:enviroewatch/helper/api_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class ProfileProvider with ChangeNotifier {
  final ProfileRepo profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;

    Future<ResponseModel> getUserInfo(BuildContext context) async {
    ResponseModel _responseModel;
    ApiResponse apiResponse = await profileRepo.getUserInfo();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response?.data);
      _responseModel = ResponseModel(true, 'successful');
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  late File _file;
  late XFile _data;

  XFile get data => _data;

  File get file => _file;
  final picker = ImagePicker();

  String _country = '';
  String get country => _country;
  set country(String newValue) {
    _country = newValue;
    notifyListeners();
  }

  void choosePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    if (pickedFile != null) {
      _file = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    notifyListeners();
  }

  void pickImage() async {
    _data = (await picker.pickImage(source: ImageSource.gallery, maxHeight: 100, maxWidth: 100, imageQuality: 20))!;
    notifyListeners();
  }

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, File file, XFile data, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    http.StreamedResponse response = await profileRepo.updateProfile(updateUserModel, file, data, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, message);
      print(message);
    } else {
      _responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }
}
