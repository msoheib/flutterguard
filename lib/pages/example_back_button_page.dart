import 'package:flutter/material.dart';
import '../components/navigation/app_bars/custom_app_bar.dart';

class ExampleBackButtonPage extends StatelessWidget {
  const ExampleBackButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'نظام المتطوع',
        centerTitle: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'هذه صفحة مثال لعرض شريط التطبيقات الجديد',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CA6A8),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'العودة',
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