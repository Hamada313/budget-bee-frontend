import 'package:budget_bee/utilities/constants/colors.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorButton extends StatelessWidget {
  const ProgressIndicatorButton({
    super.key,
    required this.color,
  });
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
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
    );
  }
}
