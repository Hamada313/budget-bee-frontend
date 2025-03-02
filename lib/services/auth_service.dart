import 'package:budget_bee/di/di_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = getIt<Dio>();
  final _storage = getIt<SharedPreferences>();
  AuthService();

  Future<Response> registerRequest(
      String name, String email, String pass) async {
    try {
      var response = await _dio.post(
        "register",
        data: {
          'name': name,
          'email': email,
          'password': pass,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> verifyRequest(String otp) async {
    try {
      var response = await _dio.post(
        "verify",
        data: {
          'otp': otp,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> otpRequest() async {
    try {
      var response = await _dio.post(
        "otp",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> resetPassOtpRequest({required String email}) async {
    try {
      var response = await _dio.post(
        "reset/otp",
        data: {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> resetPassRequest(
      {required String otp,
      required String pass,
      required String confirmedPass}) async {
    try {
      var response = await _dio.post(
        "reset/password",
        data: {
          'email': _storage.get('email'), 
          'otp': otp,
          'password': pass,
          'password_confirmation': confirmedPass
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logoutRequest() async {
    try {
      var response = await _dio.post(
        "logout",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> loginRequest(String email, String pass) async {
    try {
      var response = await _dio.post(
        "/login",
        data: {
          'email': email,
          'password': pass,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> refreshTokenRequest() async {
    try {
      var response = await _dio.post("refresh");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  bool isLogin() {
    try {
      return _storage.get('token') != null;
    } catch (e) {
      return false;
    }
  }

  bool isVerified() {
    try {
      return _storage.get('email_verified_at') != null;
    } catch (e) {
      if (kDebugMode) {
        print("error in isVerified due to exception $e");
      }
      return false;
    }
  }
}
