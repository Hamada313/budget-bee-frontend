import 'package:budget_bee/di/di_container.dart';
import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/constants.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:budget_bee/utilities/dialogs/dialogs.dart';
import 'package:budget_bee/utilities/tansitions/push_navigate.dart';
import 'package:budget_bee/utilities/validators/auth_validator.dart';
import 'package:budget_bee/view-model/auth_provider.dart';
import 'package:budget_bee/view/screens/authentication/register_screen.dart';
import 'package:budget_bee/view/screens/business%20logic/main_screen.dart';
import 'package:budget_bee/view/widgets/authentication/auth_field_section.dart';
import 'package:budget_bee/view/widgets/authentication/google_button.dart';
import 'package:budget_bee/view/widgets/authentication/or_divider.dart';
import 'package:budget_bee/view/widgets/authentication/reset_pass_sheet.dart';
import 'package:budget_bee/view/widgets/global/customed_button.dart';
import 'package:budget_bee/view/widgets/global/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _resetEmailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailInput.dispose();
    _passwordInput.dispose();
    super.dispose();
  }
  @override
  void deactivate() {
    for (var controller in HConstants.otpInputFields) {
      controller.clear();
    }
    for (var node in HConstants.otpFocusNodes) {
      node.unfocus();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    getIt<HDialogManager>().context = context;
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).hasFocus
              ? FocusScope.of(context).unfocus()
              : null,
          child: Scaffold(
            backgroundColor: HColor.background,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 29),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 45.67),
                        SizedBox(
                          width: 207,
                          height: 174.5,
                          child: Image.asset(
                            'assets/images/login_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 37.84),
                        Column(
                          spacing: 11,
                          children: [
                            AuthFieldSection(
                              title: 'Email',
                              controller: _emailInput,
                              focus: _emailFocus,
                              validator: (value) =>
                                  HValidator.validateEmail(value),
                            ),
                            AuthFieldSection(
                              title: 'Password',
                              focus: _passwordFocus,
                              isPassword: true,
                              controller: _passwordInput,
                              validator: (value) =>
                                  HValidator.validatePassword(value),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: GestureDetector(
                            onTap: () {
                              final TextEditingController resetEmailInput =
                                  TextEditingController(text: _emailInput.text);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                builder: (context) {
                                  return ResetPasswordSheet(
                                    resetFormKey: _resetFormKey,
                                    resetEmailFocus: _resetEmailFocus,
                                    resetEmailInput: resetEmailInput,
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: HColor.secondary,
                                fontFamily: 'Cairo',
                                fontSize: HSizes.regular,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        authProvider.isLoggingIn
                            ? const ProgressIndicatorButton(
                                color: HColor.secondary,
                              )
                            : CustomedButton(
                                text: "Login",
                                action: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    bool success = await authProvider.login(
                                        _emailInput.text, _passwordInput.text);
                                    if (success) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        PushTransitionPageRoute(
                                          page: const MainScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                                color: HColor.secondary,
                              ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PushTransitionPageRoute(
                                page: const RegisterScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: HColor.secondary,
                                fontFamily: 'Cairo',
                                fontSize: HSizes.regular,
                                fontWeight: FontWeight.w800,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                    color: HColor.secondary,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationColor: HColor.secondary,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    fontFamily: 'Cairo',
                                    fontSize: HSizes.regular,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        const OrDivider(color: HColor.secondary),
                        const SizedBox(height: 17),
                        GoogleSignInButton(
                          authProvider: authProvider,
                          sideColor: HColor.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
