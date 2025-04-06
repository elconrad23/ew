import 'package:dio/dio.dart';
import 'package:enviroewatch/data/repository/auth_repo.dart';
import 'package:enviroewatch/data/repository/profile_repo.dart';
import 'package:enviroewatch/data/repository/splash_repo.dart';
import 'package:enviroewatch/provider/auth_provider.dart';
import 'package:enviroewatch/provider/localization_provider.dart';
import 'package:enviroewatch/provider/profile_provider.dart';
import 'package:enviroewatch/provider/report_provider.dart';
import 'package:enviroewatch/provider/splash_provider.dart';
import 'package:enviroewatch/provider/theme_provider.dart';
import 'package:enviroewatch/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repository/report_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
 
  sl.registerLazySingleton(
      () => AuthRepo(sharedPreferences: sl(), dioClient: sl()));
 
  sl.registerLazySingleton(
      () => ProfileRepo(sharedPreferences: sl(), dioClient: sl()));
 
 sl.registerLazySingleton(
      () => ReportRepo(sharedPreferences: sl(), dioClient: sl()));
 
  
  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl(),dioClient: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => ReportProvider(reportRepo:sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
}
