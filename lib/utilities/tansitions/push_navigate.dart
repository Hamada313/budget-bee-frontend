import 'package:flutter/material.dart';

class PushTransitionPageRoute extends PageRouteBuilder {
  final Widget page;

  PushTransitionPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Start from right
            const end = Offset(0.0, 0.0); // End at center
            const curve = Curves.linear; // Smooth easing

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

