import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recyclers/navbar.dart';
import 'recyclers/company_navbar.dart';

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
        
        print('User doc exists: ${userDoc.exists}');
        if (userDoc.exists) {
          print('User data: ${userDoc.data()}');
        }
      }

      // Always set role and loading state regardless of user doc
      if (mounted) {
        setState(() {
          userRole = 'company';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error getting user role: $e');
      if (mounted) {
        setState(() {
          userRole = 'company';
          _isLoading = false;
        });
      }
    }
    print('User role set to: $userRole, isLoading: $_isLoading');
  }

  @override
  Widget build(BuildContext context) {
    print('Building AuthenticatedLayout - isLoading: $_isLoading, userRole: $userRole');
    
    // Always show the navbar for company users
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CompanyNavbar(
        currentIndex: widget.currentIndex ?? 0,
        onTap: widget.onNavItemTap ?? (_) {},
      ),
    );
  }
} 