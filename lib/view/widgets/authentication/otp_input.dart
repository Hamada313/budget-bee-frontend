import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/constants.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';

class OtpInputContainer extends StatelessWidget {
  const OtpInputContainer({
    super.key,
    required this.index,
    required this.color,
  });
  final int index;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 40,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      decoration: ShapeDecoration(
        color: HColor.background,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: HColor.inactiveBg,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Center(
        child: TextFormField(
          controller: HConstants.otpInputFields[index],
          focusNode: HConstants.otpFocusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          cursorColor: color,
          cursorErrorColor: color,
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration(
            counter: SizedBox(),
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            border: InputBorder.none,
          ),
          style: const TextStyle(
            color: HColor.text,
            fontSize: HSizes.h6,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < HConstants.otpInputs - 1) {
                HConstants.otpFocusNodes[index + 1].requestFocus();
              }
            }
            if (value.isEmpty) {
              if (index > 0) {
                HConstants.otpFocusNodes[index - 1].requestFocus();
              }
            }
            if (index == HConstants.otpInputs - 1 && value.isNotEmpty ||
                index == 0 && value.isEmpty) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ),
    );
  }
}
