import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';

class UpdatePassField extends StatelessWidget {
  const UpdatePassField({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.focusNode,
    this.type = 'password',
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final String type;
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: type == 'password'
          ? TextInputType.visiblePassword
          : TextInputType.number,
      focusNode: focusNode,
      cursorColor: HColor.secondary,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: HColor.text,
          fontSize: HSizes.regular,
          fontWeight: FontWeight.w600,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: HColor.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: HColor.text),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
