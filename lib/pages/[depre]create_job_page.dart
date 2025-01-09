import 'package:flutter/material.dart';
import '../widgets/company_route_wrapper.dart';

class CreateJobPage extends StatelessWidget {
  const CreateJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CompanyRouteWrapper(
      currentIndex: -1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة وظيفة جديدة'),
        ),
        body: const Center(
          child: Text(
            'إضافة وظيفة جديدة',
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