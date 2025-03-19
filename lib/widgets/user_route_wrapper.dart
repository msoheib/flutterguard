import 'package:flutter/material.dart';
import '../components/navigation/nav_bars/user_nav_bar.dart';

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
    
    print('UserRouteWrapper: Navigating to index $index from current index $currentIndex');
    
    switch (index) {
      case 0:
        print('UserRouteWrapper: Navigating to /jobseeker/home');
        Navigator.pushReplacementNamed(context, '/jobseeker/home');
        break;
      case 1:
        print('UserRouteWrapper: Navigating to /jobseeker/applications');
        Navigator.pushReplacementNamed(context, '/jobseeker/applications');
        break;
      case 2:
        print('UserRouteWrapper: Navigating to /jobseeker/chat');
        Navigator.pushReplacementNamed(context, '/jobseeker/chat');
        break;
      case 3:
        print('UserRouteWrapper: Navigating to /jobseeker/settings');
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