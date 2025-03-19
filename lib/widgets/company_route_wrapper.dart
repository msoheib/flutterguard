import 'package:flutter/material.dart';
import '../components/navigation/nav_bars/company_nav_bar.dart';

class CompanyRouteWrapper extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const CompanyRouteWrapper({
    super.key,
    required this.child,
    required this.currentIndex,
  });
  
  void _handleNavigation(BuildContext context, int index) {
    if (currentIndex == index) return;
    
    print('CompanyRouteWrapper: Navigating to index $index from current index $currentIndex');
    
    switch (index) {
      case 0:
        print('CompanyRouteWrapper: Navigating to /company/home');
        Navigator.pushReplacementNamed(context, '/company/home');
        break;
      case 1:
        print('CompanyRouteWrapper: Navigating to /company/applications');
        Navigator.pushReplacementNamed(context, '/company/applications');
        break;
      case 2:
        print('CompanyRouteWrapper: Navigating to /company/chat');
        Navigator.pushReplacementNamed(context, '/company/chat');
        break;
      case 3:
        print('CompanyRouteWrapper: Navigating to /company/settings');
        Navigator.pushReplacementNamed(context, '/company/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CompanyNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }
} 