import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:budget_bee/utilities/tansitions/push_navigate.dart';
import 'package:budget_bee/view/screens/authentication/login_screen.dart';
import 'package:budget_bee/view/screens/authentication/register_screen.dart';
import 'package:budget_bee/view/widgets/global/customed_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HColor.background,
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: -300,
                left: 0,
                right: -125,
                child: Image.asset(
                  'assets/images/Budget-Bee-03.png',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.1),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 36),
                      SizedBox(
                        width: 92,
                        height: 107.64,
                        child: Image.asset(
                          'assets/images/Budget-Bee-bo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 147.86,
                        height: 15,
                        child: Image.asset(
                          'assets/images/Name-Logo-Black.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 69),
                      const Text(
                        'Every Expense is tracked',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: HColor.text,
                          fontSize: HSizes.h5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Achieve financial stability and mindfulness. Start managing your expenses today—because every penny counts!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: HColor.text,
                          fontSize: HSizes.h6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 115),
                      CustomedButton(
                        color: HColor.primary,
                        action: () {
                          Navigator.push(
                            context,
                            PushTransitionPageRoute(
                              page: const RegisterScreen(),
                            ),
                          );
                        },
                        text: 'Get started',
                      ),
                      const SizedBox(height: 9),
                      CustomedButton(
                        text: 'Already have an account',
                        action: () {
                          Navigator.push(
                            context,
                            PushTransitionPageRoute(
                              page: const LoginScreen(),
                            ),
                          );
                        },
                        color: HColor.secondary,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'version 1.0.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: HColor.text,
                          fontSize: HSizes.regular,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
