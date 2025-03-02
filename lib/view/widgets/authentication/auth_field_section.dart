import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';

class AuthFieldSection extends StatefulWidget {
  const AuthFieldSection({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.focus,
    this.isPassword = false,
  });
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final FocusNode focus;
  @override
  State<AuthFieldSection> createState() => _AuthFieldSectionState();
}

class _AuthFieldSectionState extends State<AuthFieldSection> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: HColor.text,
            fontSize: HSizes.regular,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: widget.focus,
          validator: widget.validator,
          cursorColor: HColor.black,
          cursorErrorColor: HColor.black,
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: HColor.text,
            fontSize: HSizes.regular,
            fontWeight: FontWeight.w600,
          ),
          keyboardType: widget.title == "Email"
              ? TextInputType.emailAddress
              : TextInputType.text,
          obscureText: widget.isPassword ? hidePassword : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: HColor.nuetral,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                    color: HColor.text,
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  )
                : null,
          ),
          controller: widget.controller,
        )
      ],
    );
  }
}
