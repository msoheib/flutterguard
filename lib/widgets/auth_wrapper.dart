// widgets/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/job_seeker_home_page.dart';
import '../pages/company/company_home_page.dart';
import '../pages/admin/admin_dashboard_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const LoginPage();
        }

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data!.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const LoginPage();
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final userRole = userData['role'] as String?;

            switch (userRole) {
              case 'admin':
              case 'superadmin':
                return const AdminDashboardPage();
              case 'company':
                return const CompanyHomePage();
              case 'jobseeker':
                return const JobSeekerHomePage();
              default:
                return const LoginPage();
            }
          },
        );
      },
    );
  }
}