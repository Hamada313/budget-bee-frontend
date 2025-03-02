import 'dart:async';
import 'package:budget_bee/di/di_container.dart';
import 'package:budget_bee/model/user.dart';
import 'package:budget_bee/services/auth_service.dart';
import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/constants.dart';
import 'package:budget_bee/utilities/dialogs/dialogs.dart';
import 'package:budget_bee/utilities/tansitions/push_navigate.dart';
import 'package:budget_bee/utilities/toasts/message_toast.dart';
import 'package:budget_bee/view/screens/authentication/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final _send = getIt<AuthService>();
  final _storage = getIt<SharedPreferences>();

  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;
  set setIsRegistering(bool value) {
    _isRegistering = value;
    notifyListeners();
  }

  bool _isLoggingIn = false;
  bool get isLoggingIn => _isLoggingIn;
  set setIsLoggingIn(bool value) {
    _isLoggingIn = value;
    notifyListeners();
  }

  bool _resendingCode = false;
  bool get resendingCode => _resendingCode;
  set setResendingCode(bool value) {
    _resendingCode = value;
    notifyListeners();
  }

  bool _resetPassLoading = false;
  bool get resetPassLoading => _resetPassLoading;
  set setResetPassLoading(bool value) {
    _resetPassLoading = value;
    notifyListeners();
  }

  bool _logoutLoading = false;
  bool get logoutLoading => _logoutLoading;
  set setlogoutLoading(bool value) {
    _logoutLoading = value;
    notifyListeners();
  }

  Timer? _timer;
  Timer? get getTimer => _timer;
  set setTimer(Timer? value) {
    _timer = value;
  }

  Duration _timerDuration = const Duration(minutes: 3);
  Duration get getTimerDuration => _timerDuration;
  set setTimerDuration(Duration value) {
    _timerDuration = value;
    notifyListeners();
  }

  void startTimer() {
    if (getTimer != null) {
      if (getTimer!.isActive) {
        getTimer!.cancel();
        setTimerDuration = const Duration(minutes: 3);
      }
    }

    setTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (getTimerDuration.inMinutes == 0 &&
            (getTimerDuration.inSeconds % 60) == 0) {
          getTimer!.cancel();
          setTimerDuration = const Duration(minutes: 3);
          return;
        }
        setTimerDuration = getTimerDuration - const Duration(seconds: 1);
      },
    );
  }

  Future<bool> register(String name, String email, String pass) async {
    try {
      setIsRegistering = true;
      var response = await _send.registerRequest(name, email, pass);
      if (response.statusCode == 201) {
        setIsRegistering = false;
        await _storage.setString('token', response.data['results']['token']);
        User user = User.fromJson(response.data['results']['user']);
        user.email_verified_at != null
            ? await _storage.setString(
                "email_verified_at", user.email_verified_at as String)
            : null;
        await _storage.setString('email', user.email);
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightPrimary);
        return true;
      } else {
        setIsRegistering = false;
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightPrimary);
        return false;
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("failed to register due to exception $e");
      }
      if (HConstants.internetError.contains(e.type)) {
        MessageToast.showMessageToast(
            "Please check your internet connection", HColor.lightPrimary);
      }
      setIsRegistering = false;
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("failed to login due to exception $e");
      }
      setIsRegistering = false;
      return false;
    }
  }

  Future<bool> login(String email, String pass) async {
    try {
      setIsLoggingIn = true;
      var response = await _send.loginRequest(email, pass);
      if (response.statusCode == 200) {
        setIsLoggingIn = false;
        await _storage.setString('token', response.data['results']['token']);
        if (response.data["message"] ==
            'Login succefull! Please verify account with OTP') {
          getIt<HDialogManager>().showOtpDialog(
              userEmail: email,
              color: HColor.secondary,
              type: 'because session expired');

          MessageToast.showMessageToast(
              response.data['message'], HColor.lightSecondary);
          return false;
        }
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightSecondary);
        return true;
      } else {
        setIsLoggingIn = false;
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightSecondary);
        return false;
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("failed to login due to exception $e");
      }
      if (HConstants.internetError.contains(e.type)) {
        MessageToast.showMessageToast(
            "Please check your internet connection", HColor.lightSecondary);
      }
      setIsLoggingIn = false;
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("failed to login due to exception $e");
      }
      setIsLoggingIn = false;
      return false;
    }
  }

  Future<void> resendOtp() async {
    try {
      setResendingCode = true;
      var response = await _send.otpRequest();
      if (response.statusCode == 200) {
        setResendingCode = false;
        startTimer();
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightPrimary);
      }
      if (response.statusCode == 401) {
        setResendingCode = false;
        Navigator.pushReplacement(getIt<HDialogManager>().getContext!,
            PushTransitionPageRoute(page: const LoginScreen()));
        MessageToast.showMessageToast(
            "Session expired. Please login to verify", HColor.lightSecondary);
      } else {
        setResendingCode = false;
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightPrimary);
      }
    } catch (e) {
      setResendingCode = false;
      if (kDebugMode) {
        print("failed to resend otp due to exception $e");
      }
      MessageToast.showMessageToast(
          'Something went wrong', HColor.lightPrimary);
    }
  }

  Future<bool> logout() async {
    try {
      setlogoutLoading = true;
      var response = await _send.logoutRequest();
      if (response.statusCode == 200) {
        setlogoutLoading = false;
        await _storage.remove('token');
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightPrimary);
        return true;
      }
      if (response.statusCode == 401) {
        setlogoutLoading = false;
        MessageToast.showMessageToast(
            "Session expired. Please login to verify", HColor.lightSecondary);
        return false;
      } else {
        setlogoutLoading = false;
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightPrimary);
        return false;
      }
    } catch (e) {
      setlogoutLoading = false;
      if (kDebugMode) {
        print("failed to logout due to exception $e");
      }
      MessageToast.showMessageToast(
          'Something went wrong', HColor.lightPrimary);
      return false;
    }
  }

  Future<bool> resetPassOtp({required String email}) async {
    try {
      setResetPassLoading = true;
      var response = await _send.resetPassOtpRequest(email: email);
      if (response.statusCode == 200) {
        setResetPassLoading = false;
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightSecondary);
        return true;
      }
      if (response.statusCode == 401) {
        setResetPassLoading = false;
        MessageToast.showMessageToast(
            "Session expired. Please login to verify", HColor.lightSecondary);
        return false;
      } else {
        setResetPassLoading = false;
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightSecondary);
        return false;
      }
    } catch (e) {
      setResetPassLoading = false;
      if (kDebugMode) {
        print("failed to recieve reset pass otp due to exception $e");
      }
      MessageToast.showMessageToast(
          'Something went wrong', HColor.lightSecondary);
      return false;
    }
  }

  Future<bool> resetPassword(
      {required String otp,
      required String pass,
      required String confirmedPass}) async {
    try {
      setResetPassLoading = true;
      var response = await _send.resetPassRequest(
          otp: otp, pass: pass, confirmedPass: confirmedPass);
      if (response.statusCode == 200) {
        setResetPassLoading = false;
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightSecondary);
        return true;
      }
      if (response.statusCode == 401) {
        setResetPassLoading = false;
        MessageToast.showMessageToast(
            "Session expired. Please login to verify", HColor.lightSecondary);
        return false;
      } else {
        setResetPassLoading = false;
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightSecondary);
        return false;
      }
    } catch (e) {
      setResetPassLoading = false;
      if (kDebugMode) {
        print("failed to reset password due to exception $e");
      }
      MessageToast.showMessageToast(
          'Something went wrong', HColor.lightSecondary);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      setIsRegistering = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (kDebugMode) {
        print("google sign in name ${googleUser?.displayName}");
        print("google sign in email ${googleUser?.email}");
        print('google sign in token ${googleAuth?.accessToken}');
      }
      await _storage.setString('token', googleAuth!.accessToken!);
      setIsRegistering = false;
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("failed to sign in with google due to exception $e");
      }
      setIsRegistering = false;
      return false;
    }
  }

  Future<bool> verifyAccount({required String otp}) async {
    try {
      setIsRegistering = true;
      var response = await _send.verifyRequest(otp);

      if (response.statusCode == 200) {
        MessageToast.showMessageToast(
            response.data['message'], HColor.lightPrimary);
        setIsRegistering = false;
        return true;
      }
      if (response.statusCode == 401) {
        Navigator.pushReplacement(getIt<HDialogManager>().getContext!,
            PushTransitionPageRoute(page: const LoginScreen()));
        MessageToast.showMessageToast(
            "Session expired. Please login to verify", HColor.lightSecondary);
        setIsRegistering = false;
        return false;
      }
      setIsRegistering = false;
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("failed to verify account due to exception $e");
      }
      setIsRegistering = false;
      return false;
    }
  }

  bool isLoggedIn() {
    return _send.isLogin();
  }

  bool isVerified() {
    return _send.isVerified();
  }
}
