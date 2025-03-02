import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomedButton extends StatelessWidget {
  const CustomedButton({
    super.key,
    required this.text,
    required this.action,
    required this.color,
  });

  final String text;
  final void Function()? action;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      minWidth: double.infinity,
      height: 45,
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusElevation: 0,
      highlightElevation: 0,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Cairo',
          color: HColor.fullWhite,
          fontSize: HSizes.regular,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
