import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recyclers/navbar.dart';
import 'recyclers/company_navbar.dart';

class AuthenticatedLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AuthenticatedLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

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
              ? CompanyNavbar(currentIndex: currentIndex)
              : Navbar(currentIndex: currentIndex),
        );
      },
    );
  }
} 