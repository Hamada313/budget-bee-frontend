import 'package:budget_bee/dio/authorized_interceptor.dart';
import 'package:budget_bee/services/auth_service.dart';
import 'package:budget_bee/utilities/dialogs/dialogs.dart';
import 'package:budget_bee/view-model/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //services
  getIt.registerLazySingleton(() => AuthService());

  //models
  getIt.registerFactory(() => AuthProvider());

  //tools
  getIt.registerLazySingleton(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        baseUrl: "http://10.0.2.2:8000/api/",
        responseType: ResponseType.json,
        contentType: "application/json",
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    ),
  );

  getIt<Dio>().interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
          //   enabled: kDebugMode,
          //   filter: (options, args){
          //       // don't print requests with uris containing '/posts'
          //       if(options.path.contains('/posts')){
          //         return false;
          //       }
          //       // don't print responses with unit8 list data
          //       return !args.isResponse || !args.hasUint8ListData;
          //     }
        ),
      );

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton(() => HDialogManager());

  getIt<Dio>().interceptors.add(AuthorizedInterceptor());
}
