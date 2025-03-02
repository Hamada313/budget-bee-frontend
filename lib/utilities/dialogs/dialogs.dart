import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/constants.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:budget_bee/utilities/tansitions/push_navigate.dart';
import 'package:budget_bee/utilities/validators/auth_validator.dart';
import 'package:budget_bee/view-model/auth_provider.dart';
import 'package:budget_bee/view/screens/authentication/welcome_screen.dart';
import 'package:budget_bee/view/screens/business%20logic/main_screen.dart';
import 'package:budget_bee/view/widgets/authentication/otp_input.dart';
import 'package:budget_bee/view/widgets/authentication/update_pass_field.dart';
import 'package:budget_bee/view/widgets/global/customed_button.dart';
import 'package:budget_bee/view/widgets/global/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HDialogManager {
  BuildContext? _context;
  BuildContext? get getContext => _context;
  set context(val) => _context = val;

  void showOtpDialog(
      {required String userEmail,
      String type = 'to verify',
      Color color = HColor.primary}) {
    var provider = Provider.of<AuthProvider>(_context!, listen: false);
    if (provider.getTimer == null || type == 'because session expired') {
      provider.startTimer();
    }
    showGeneralDialog(
      context: _context!,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              CurvedAnimation(parent: animation, curve: Curves.easeIn).drive(
            Tween(
              begin: const Offset(0, 1.0),
              end: const Offset(0, 0),
            ),
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return PopScope(
              // canPop: type == 'not verified' ? false : true,
              canPop: true,
              child: Center(
                child: Material(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    constraints: BoxConstraints.tightFor(
                        height: type == "not verified" ? 320 : 267, width: 344),
                    decoration: BoxDecoration(
                      color: HColor.background,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 29, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Enter verification code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: color,
                            fontSize: HSizes.h5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1,
                          TextSpan(
                            text: 'We’ve send code to ',
                            style: const TextStyle(
                              color: HColor.text,
                              fontSize: HSizes.regular,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: userEmail,
                                style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: color,
                                  fontSize: HSizes.regular,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List<OtpInputContainer>.generate(
                            HConstants.otpInputs,
                            (index) {
                              return OtpInputContainer(
                                color: color,
                                index: index,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        authProvider.getTimer!.isActive
                            ? Text(
                                "${authProvider.getTimerDuration.inMinutes.toString().padLeft(2, "0")}:${(authProvider.getTimerDuration.inSeconds % 60).toString().padLeft(2, "0")}")
                            : authProvider.resendingCode
                                ? const Text(
                                    "Sending code ....",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: HSizes.small,
                                      color: HColor.text,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      for (var controller
                                          in HConstants.otpInputFields) {
                                        controller.clear();
                                      }
                                      authProvider.resendOtp();
                                    },
                                    child: const Text(
                                      "Resend code?",
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: HSizes.small,
                                        color: HColor.text,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: HColor.text,
                                      ),
                                    ),
                                  ),
                        const SizedBox(height: 18),
                        authProvider.isRegistering
                            ? ProgressIndicatorButton(color: color)
                            : CustomedButton(
                                text: "Verify",
                                action: () async {
                                  var otp = HConstants.otpInputFields
                                      .map((controller) =>
                                          controller.text.toString())
                                      .join();
                                  var success =
                                      await authProvider.verifyAccount(
                                    otp: otp,
                                  );
                                  if (success) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      PushTransitionPageRoute(
                                          page: const MainScreen()),
                                      (route) => false,
                                    );
                                  }
                                },
                                color: color,
                              ),
                        const SizedBox(height: 8),
                        type == "not verified"
                            ? authProvider.logoutLoading
                                ? ProgressIndicatorButton(color: color)
                                : OutlinedButton(
                                    onPressed: () async {
                                      var success = await authProvider.logout();
                                      if (success) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          PushTransitionPageRoute(
                                              page: const WelcomeScreen()),
                                          (route) => false,
                                        );
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      fixedSize:
                                          const Size(double.infinity, 45),
                                      side: BorderSide(color: color, width: 1),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: color,
                                        fontSize: HSizes.regular,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showResetPasswordDialog() {
    final TextEditingController otpController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final TextEditingController confirmedPassController =
        TextEditingController();
    final FocusNode otpFocus = FocusNode();
    final FocusNode passFocus = FocusNode();
    final FocusNode confirmedPassFocus = FocusNode();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showGeneralDialog(
      context: _context!,
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context2, animation, secondaryAnimation) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  otpController.dispose();
                  otpFocus.unfocus();
                  passController.dispose();
                  passFocus.unfocus();
                  confirmedPassController.dispose();
                  confirmedPassFocus.unfocus();
                },
              );
            }
          },
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Form(
                key: formKey,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(35),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 337,
                          maxHeight: 402,
                          minHeight: 342,
                          maxWidth: 337,
                        ),
                        decoration: BoxDecoration(
                          color: HColor.background,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 18,
                          children: [
                            const Text(
                              "Reset Password",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: HColor.text,
                                fontSize: HSizes.h5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            UpdatePassField(
                              controller: otpController,
                              focusNode: otpFocus,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter verification code';
                                } else if (value.length != 4) {
                                  return 'Verification code must be 4 characters';
                                }
                              },
                              hintText: 'Verification Code',
                              type: 'otp',
                            ),
                            UpdatePassField(
                              controller: passController,
                              focusNode: passFocus,
                              validator: (value) =>
                                  HValidator.validatePassword(value),
                              hintText: 'New Password',
                            ),
                            UpdatePassField(
                              controller: confirmedPassController,
                              focusNode: confirmedPassFocus,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please re-type new password';
                                } else if (value != passController.text) {
                                  confirmedPassFocus.requestFocus();
                                  return 'Passwords do not match';
                                }
                              },
                              hintText: 'Re-type new password',
                            ),
                            authProvider.resetPassLoading
                                ? const ProgressIndicatorButton(
                                    color: HColor.secondary)
                                : CustomedButton(
                                    text: "Reset",
                                    action: () async {
                                      if (formKey.currentState!.validate()) {
                                        var success =
                                            await authProvider.resetPassword(
                                          otp: otpController.text.trim(),
                                          pass: passController.text,
                                          confirmedPass:
                                              confirmedPassController.text,
                                        );
                                        if (success) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    color: HColor.secondary,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
