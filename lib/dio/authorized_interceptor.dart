import 'package:budget_bee/di/di_container.dart';
import 'package:budget_bee/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizedInterceptor extends InterceptorsWrapper {
  final _storage = getIt<SharedPreferences>();
  final _send = getIt<AuthService>();
  final _dio = getIt<Dio>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print("token in onRequest ${_storage.getString("token")}");
    }

    String? token = _storage.getString("token");
    options.headers["Accept"] = "application/json";
    options.headers["Authorization"] = 'Bearer $token';

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (err.response?.data["error"] == "Unauthorized") {
        return handler.reject(err);
      }
      if (err.response?.data["message"] == "Unauthenticated.") {
        return handler.reject(err);
      }
      final refreshedToken = await _refreshToken();
      if (refreshedToken != null) {
        err.requestOptions.headers["Authorization"] = 'Bearer $refreshedToken';
        return handler.resolve(await _dio.fetch(err.requestOptions));
      }
      return handler.next(err);
    }
    return handler.next(err);
  }

  Future<String?> _refreshToken() async {
    try {
      var response = await _send.refreshTokenRequest();
      if (response.statusCode == 200) {
        var data = response.data;
        await _storage.setString('token', data["token"]);
        return data["token"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
