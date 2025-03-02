import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HConstants {
  HConstants._();
  static final internetError = [
    DioExceptionType.connectionTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.connectionError
  ];

  static const otpInputs = 4;

  static final otpInputFields = List<TextEditingController>.generate(
      otpInputs, (index) => TextEditingController());

  static final otpFocusNodes =
      List<FocusNode>.generate(otpInputs, (index) => FocusNode());
}
