import 'package:flutter/material.dart';
import '../widgets/common/app_header.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(
            title: 'الأسئلة الشائعة',
            showBackButton: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ExpansionTile(
                  title: Text('كيف يمكنني التقديم على وظيفة؟'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'يمكنك التقديم على الوظائف من خلال تصفح الوظائف المتاحة والضغط على زر "تقديم" في الوظيفة التي تناسبك.',
                      ),
                    ),
                  ],
                ),
                // Add more FAQ items
              ],
            ),
          ),
        ],
      ),
    );
  }
} 