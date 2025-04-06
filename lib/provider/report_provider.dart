import 'dart:convert';
import 'dart:io';

import 'package:enviroewatch/data/model/body/report_body.dart';
import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/data/model/response/report_model.dart';
import 'package:enviroewatch/data/model/response/response_model.dart';
import 'package:enviroewatch/data/repository/report_repo.dart';
import 'package:enviroewatch/helper/api_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends ChangeNotifier {
  late final ReportRepo reportRepo;
  ReportProvider({required this.reportRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _messageErrorMessage = '';

  String get messageErrorMessage => _messageErrorMessage;

  late List<ReportsModel> _historyList;
  List<ReportsModel> get historyList => _historyList;

  late ReportsModel _reportModel;

  ReportsModel get report => _reportModel;

  late File _file;
  File get file => _file;
  
  Future<void> getreportList(BuildContext context) async {
    ApiResponse apiResponse = await reportRepo.getreportList();
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _historyList = [];
      apiResponse.response?.data.forEach((report) {
        ReportsModel repoModel = ReportsModel.fromJson(report);
        _historyList.add(repoModel);
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> senddata(
      ReportBody reportModel, File file, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    http.StreamedResponse response =
        await reportRepo.senddata(reportModel, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      // _reportModel = reportModel;
      _responseModel = ResponseModel(true, message);
      print(message);
    } else {
      _responseModel = ResponseModel(
          false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }
}
