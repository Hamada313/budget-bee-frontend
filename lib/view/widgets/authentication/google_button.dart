import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:budget_bee/utilities/tansitions/push_navigate.dart';
import 'package:budget_bee/view-model/auth_provider.dart';
import 'package:budget_bee/view/screens/business%20logic/main_screen.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.authProvider,
    required this.sideColor,
  });
  final AuthProvider authProvider;
  final Color sideColor;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        var success = await authProvider.signInWithGoogle();
        if (success) {
          Navigator.pushAndRemoveUntil(
            context,
            PushTransitionPageRoute(
              page: const MainScreen(),
            ),
            (route) => false,
          );
        }
        
      },
      style: OutlinedButton.styleFrom(
        overlayColor: HColor.lightPrimary,
        side: BorderSide(
          color: sideColor,
          width: 1,
        ),
        fixedSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        spacing: 60,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Image.asset(
              'assets/images/google.png',
              fit: BoxFit.contain,
            ),
          ),
          const Text(
            'Sign in with Google',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: HColor.text,
              fontSize: HSizes.h6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
