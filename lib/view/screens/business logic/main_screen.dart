import 'package:budget_bee/di/di_container.dart';
import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/dialogs/dialogs.dart';
import 'package:budget_bee/utilities/tansitions/push_navigate.dart';
import 'package:budget_bee/view-model/auth_provider.dart';
import 'package:budget_bee/view/screens/authentication/welcome_screen.dart';
import 'package:budget_bee/view/widgets/global/customed_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    getIt<HDialogManager>().context = context;
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Scaffold(
        backgroundColor: HColor.background,
        body: Center(
          child: CustomedButton(
            text: "Log out",
            action: () async {
              var success = await authProvider.logout();
              if (success) {
                Navigator.pushAndRemoveUntil(
                  context,
                  PushTransitionPageRoute(page: const WelcomeScreen()),
                  (route) => false,
                );
             
              }
            },
            color: HColor.primary,
          ),
        ),
      );
    });
  }
}
