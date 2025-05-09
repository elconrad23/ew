import 'dart:async';

import 'package:enviroewatch/data/model/response/config_model.dart';
import 'package:flutter/material.dart';
import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/data/repository/splash_repo.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  late BaseUrls _baseUrls;
  bool _isConfigLoaded = false;
  int _pageIndex = 0;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool get isConfigLoaded => _isConfigLoaded;

  ConfigModel? get configModel => _configModel;
  BaseUrls get baseUrls => _baseUrls;
  int get pageIndex => _pageIndex;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> initConfig(BuildContext context) async {
    ApiResponse apiResponse = await splashRepo.getConfig();
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response?.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response?.data).baseUrls;
      isSuccess = true;
      _isConfigLoaded = true;
      notifyListeners();
    } else {
      isSuccess = false;
       String errorText;
      if (apiResponse.error is String) {
        errorText = apiResponse.error;
      } else {
        errorText = apiResponse.error.errors.isNotEmpty
            ? apiResponse.error.errors.first.message
            : 'Unexpected error occurred';
      }

      setError(errorText); // Save the error message
    }
    return isSuccess;
  }


  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }
}
