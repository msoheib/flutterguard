import 'package:flutter/material.dart';
import './recyclers/user_navbar.dart';

class UserRouteWrapper extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const UserRouteWrapper({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (currentIndex == index) return;
    
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/jobseeker/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/jobseeker/applications');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/jobseeker/chat');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/jobseeker/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: UserNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }
} 