import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/navigation/nav_bars/company_nav_bar.dart';

class AuthenticatedLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AuthenticatedLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _handleCompanyNavigation(BuildContext context, int index) {
    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/company/applicants');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/company/chat');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/company/settings');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/company/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final userType = userData?['role'] as String?;

        return Scaffold(
          body: child,
          bottomNavigationBar: userType == 'company' 
              ? CompanyNavBar(
                  currentIndex: currentIndex,
                  onTap: (index) => _handleCompanyNavigation(context, index),
                )
              : null,
        );
      },
    );
  }
} 