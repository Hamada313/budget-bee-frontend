import 'package:budget_bee/di/di_container.dart';
import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/constants.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:budget_bee/utilities/dialogs/dialogs.dart';
import 'package:budget_bee/utilities/tansitions/push_navigate.dart';
import 'package:budget_bee/utilities/validators/auth_validator.dart';
import 'package:budget_bee/view-model/auth_provider.dart';
import 'package:budget_bee/view/screens/authentication/login_screen.dart';
import 'package:budget_bee/view/widgets/authentication/auth_field_section.dart';
import 'package:budget_bee/view/widgets/authentication/google_button.dart';
import 'package:budget_bee/view/widgets/authentication/or_divider.dart';
import 'package:budget_bee/view/widgets/global/customed_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthProvider? _provider;

  @override
  void initState() {
    super.initState();
    if (!Provider.of<AuthProvider>(context, listen: false).isVerified() &&
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Future.delayed(const Duration(milliseconds: 100), () {
        getIt<HDialogManager>().showOtpDialog(
            userEmail: getIt<SharedPreferences>().getString('email')!,
            type: 'not verified');
      });
    }
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<AuthProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    for (var controller in HConstants.otpInputFields) {
      controller.clear();
    }
    for (var node in HConstants.otpFocusNodes) {
      node.unfocus();
    }
    // Future.delayed(
    //   const Duration(milliseconds: 100),
    //   () async {
    //     await getIt<SharedPreferences>().remove('email');
    //   },
    // );
    super.deactivate();
  }

  @override
  void dispose() {
    if (_provider!.getTimer != null) {
      _provider!.getTimer!.cancel();
    }
    _nameInput.dispose();
    _emailInput.dispose();
    _passwordInput.dispose();
    super.dispose();
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
                        const SizedBox(height: 90.53),
                        SizedBox(
                          width: 284,
                          height: 27.86,
                          child: Image.asset(
                            'assets/images/Name-Logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: const TextSpan(
                            text: 'Create an account ',
                            style: TextStyle(
                              color: HColor.primary,
                              fontFamily: 'Cairo',
                              fontSize: HSizes.h5,
                              fontWeight: FontWeight.w800,
                            ),
                            children: [
                              TextSpan(
                                text: 'here',
                                style: TextStyle(
                                  color: HColor.secondary,
                                  fontFamily: 'Cairo',
                                  fontSize: HSizes.h5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 42),
                        Column(
                          spacing: 11,
                          children: [
                            AuthFieldSection(
                              title: 'Name',
                              controller: _nameInput,
                              focus: _nameFocus,
                              validator: (value) =>
                                  HValidator.validateName(value),
                            ),
                            AuthFieldSection(
                              title: 'Email',
                              focus: _emailFocus,
                              controller: _emailInput,
                              validator: (value) =>
                                  HValidator.validateEmail(value),
                            ),
                            AuthFieldSection(
                              title: 'Password',
                              isPassword: true,
                              focus: _passwordFocus,
                              controller: _passwordInput,
                              validator: (value) =>
                                  HValidator.validatePassword(value),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        authProvider.isRegistering
                            ? Container(
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: HColor.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: HColor.fullWhite,
                                    ),
                                  ),
                                ),
                              )
                            : CustomedButton(
                                text: "Sign up",
                                action: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    bool success = await authProvider.register(
                                      _nameInput.text,
                                      _emailInput.text,
                                      _passwordInput.text,
                                    );
                                    if (success) {
                                      getIt<HDialogManager>().showOtpDialog(
                                          userEmail: _emailInput.text);
                                    }
                                  }
                                },
                                color: HColor.primary,
                              ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PushTransitionPageRoute(
                                page: const LoginScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Already  have an account? ",
                              style: TextStyle(
                                color: HColor.primary,
                                fontFamily: 'Cairo',
                                fontSize: HSizes.regular,
                                fontWeight: FontWeight.w800,
                              ),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    color: HColor.primary,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationColor: HColor.primary,
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
                        const SizedBox(height: 15),
                        const OrDivider(color: HColor.primary),
                        const SizedBox(height: 18),
                        GoogleSignInButton(
                          authProvider: authProvider,
                          sideColor: HColor.primary,
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
