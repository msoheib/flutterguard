import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recyclers/navbar.dart';
import 'recyclers/company_navbar.dart';
import '../screens/company_profile_setup_page.dart';
import '../pages/profile_cv_screen.dart';

class AuthenticatedLayout extends StatefulWidget {
  final Widget child;
  final int? currentIndex;
  final Function(int)? onNavItemTap;

  const AuthenticatedLayout({
    super.key,
    required this.child,
    this.currentIndex,
    this.onNavItemTap,
  });

  @override
  State<AuthenticatedLayout> createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  String? userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    setState(() => _isLoading = true);
    
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      print('Current user ID: $userId');
      
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        
        if (userDoc.exists) {
          final data = userDoc.data();
          if (data != null && data['role'] != null) {
            setState(() {
              userRole = data['role'];
            });
          } else {
            print('User role not found in document');
          }
        } else {
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error getting user role: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleProfileTap(BuildContext context) {
    if (userRole == 'company') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CompanyProfileSetupPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileCvScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: userRole == 'company' 
        ? CompanyNavbar(
            currentIndex: widget.currentIndex ?? 0,
            onTap: widget.onNavItemTap ?? (_) {},
            onProfileTap: () => _handleProfileTap(context),
          )
        : Navbar(
            currentIndex: widget.currentIndex ?? 0,
            onTap: widget.onNavItemTap ?? (_) {},
          ),
    );
  }
} 