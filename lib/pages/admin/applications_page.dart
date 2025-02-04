import 'package:flutter/material.dart';
import 'components/admin_bottom_nav.dart';

class AdminApplicationsPage extends StatefulWidget {
  const AdminApplicationsPage({super.key});

  @override
  State<AdminApplicationsPage> createState() => _AdminApplicationsPageState();
}

class _AdminApplicationsPageState extends State<AdminApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... existing scaffold content ...
      bottomNavigationBar: AdminBottomNav(
        currentIndex: 1, // Applications is index 1
        onTap: (index) => AdminBottomNav.handleNavigation(context, index),
      ),
    );
  }
} 