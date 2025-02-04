import 'package:flutter/material.dart';
import 'components/admin_bottom_nav.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... existing scaffold content ...
      bottomNavigationBar: AdminBottomNav(
        currentIndex: 3, // Profile is index 3
        onTap: (index) => AdminBottomNav.handleNavigation(context, index),
      ),
    );
  }
} 