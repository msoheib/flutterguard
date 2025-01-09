import 'package:flutter/material.dart';
import './recyclers/company_navbar.dart';

class CompanyRouteWrapper extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const CompanyRouteWrapper({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CompanyNavbar(
        currentIndex: currentIndex,
      ),
    );
  }
} 