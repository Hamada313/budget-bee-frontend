import 'package:budget_bee/di/di_container.dart';
import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:budget_bee/utilities/dialogs/dialogs.dart';
import 'package:budget_bee/utilities/validators/auth_validator.dart';
import 'package:budget_bee/view-model/auth_provider.dart';
import 'package:budget_bee/view/widgets/authentication/auth_field_section.dart';
import 'package:budget_bee/view/widgets/global/customed_button.dart';
import 'package:budget_bee/view/widgets/global/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordSheet extends StatelessWidget {
  const ResetPasswordSheet({
    super.key,
    required GlobalKey<FormState> resetFormKey,
    required FocusNode resetEmailFocus,
    required this.resetEmailInput,
  })  : _resetFormKey = resetFormKey,
        _resetEmailFocus = resetEmailFocus;

  final GlobalKey<FormState> _resetFormKey;
  final FocusNode _resetEmailFocus;
  final TextEditingController resetEmailInput;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Form(
        key: _resetFormKey,
        child: GestureDetector(
          onTap: _resetEmailFocus.hasFocus
              ? () => _resetEmailFocus.unfocus()
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 29),
            decoration: const BoxDecoration(
              color: HColor.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).viewInsets.bottom != 0
                ? (310 + MediaQuery.of(context).viewInsets.bottom)
                : 310,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 22),
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: HSizes.h6,
                    color: HColor.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'We will send an email shortly with an verification code to reset your password',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: HSizes.regular,
                      color: HColor.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                AuthFieldSection(
                  title: "Email",
                  controller: resetEmailInput,
                  validator: (value) => HValidator.validateEmail(value),
                  focus: _resetEmailFocus,
                ),
                const SizedBox(height: 18),
                authProvider.resetPassLoading
                    ? const ProgressIndicatorButton(color: HColor.secondary)
                    : CustomedButton(
                        text: "Submit",
                        action: () async {
                          var success = await authProvider.resetPassOtp(
                              email: resetEmailInput.text);
                          if (success) {
                            Navigator.pop(context);
                            getIt<HDialogManager>().showResetPasswordDialog();
                          }
                        },
                        color: HColor.secondary,
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
