import 'package:flutter/material.dart';
import '../widgets/authenticated_layout.dart';

class JobManagementPage extends StatelessWidget {
  const JobManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthenticatedLayout(
      currentIndex: 1, // Jobs tab
      child: Center(
        child: Text(
          'Job Management Page',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
} 