import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:enviroewatch/data/datasource/remote/dio/dio_client.dart';
import 'package:enviroewatch/data/datasource/remote/exception/api_error_handler.dart';
import 'package:enviroewatch/data/model/body/report_body.dart';
import 'package:enviroewatch/data/model/response/base/api_response.dart';
import 'package:enviroewatch/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ReportRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ReportRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getreportList() async {
    try {
      final response = await dioClient.get(AppConstants.MY_REPORT, queryParameters: {}, options: Options(), cancelToken: CancelToken(), onReceiveProgress: (int count, int total) {  }, );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<http.StreamedResponse> senddata(
      ReportBody reportModel, File file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.SUBMIT_REPORT}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    Uint8List _list = await file.readAsBytes();
    request.files.add(new http.MultipartFile.fromBytes('image_path', _list,
        filename: basename(file.path)));

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'image_class': reportModel.resultclass,
      'degradation': reportModel.degradation,
      'productivity': reportModel.productivity,
      'accuracy': reportModel.accuracy,
      'lon': reportModel.lon,
      'lat': reportModel.lat,
      'location': reportModel.place,
      'time_of_capture': reportModel.timeOfCapture,
    });
    // print(part);
    print('${AppConstants.BASE_URL}${AppConstants.SUBMIT_REPORT}');
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
}
