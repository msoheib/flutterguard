import 'package:flutter/material.dart';
import '../widgets/authenticated_layout.dart';

class CreateJobPage extends StatelessWidget {
  const CreateJobPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'إنشاء وظيفة جديدة',
            style: TextStyle(
              color: Color(0xFF1A1D1E),
              fontSize: 18,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4CA6A8)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TODO: Add job creation form
              const Center(
                child: Text(
                  'نموذج إنشاء وظيفة جديدة',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 