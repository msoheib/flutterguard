import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanyPendingApprovalPage extends StatelessWidget {
  const CompanyPendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('حدث خطأ أثناء تسجيل الخروج'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CA6A8).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hourglass_empty,
                    size: 64,
                    color: Color(0xFF4CA6A8),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'حسابك قيد المراجعة',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'شكراً لتسجيلك في التطبيق. سيتم مراجعة طلبك من قبل الإدارة وسيتم إخطارك عند الموافقة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6A6A6A),
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CA6A8)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'يمكنك تسجيل الخروج والعودة لاحقاً للتحقق من حالة طلبك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6A6A6A),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 