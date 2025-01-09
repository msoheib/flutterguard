import 'package:flutter/material.dart';
import '../../widgets/company_route_wrapper.dart';

class CompanyApplicationsPage extends StatelessWidget {
  const CompanyApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CompanyRouteWrapper(
      currentIndex: 2,
      child: const Scaffold(
        body: Center(
          child: Text(
            'صفحة المتقدمين',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
} 