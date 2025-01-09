import 'package:flutter/material.dart';

class RouteTransitions {
  static PageRouteBuilder buildPageRoute({
    required Widget page,
    required String routeName,
    RouteTransitionType transitionType = RouteTransitionType.fade,
  }) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case RouteTransitionType.fade:
            return FadeTransition(opacity: animation, child: child);
          
          case RouteTransitionType.slideRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          
          case RouteTransitionType.slideLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
        }
      },
    );
  }
}

enum RouteTransitionType {
  fade,
  slideRight,
  slideLeft,
} 