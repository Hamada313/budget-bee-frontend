import 'package:budget_bee/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
    required this.color,
  });
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color,
            thickness: 1,
            endIndent: 5,
          ),
        ),
        Text(
          'or',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w800,
            fontSize: HSizes.regular,
            color: color,
          ),
        ),
        Expanded(
          child: Divider(
            color:color,
            thickness: 1,
            indent: 5,
          ),
        ),
      ],
    );
  }
}
