import 'package:flutter/material.dart';
import 'components/admin_bottom_nav.dart';
import '../../widgets/custom_app_bar.dart';
import '../../services/admin_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final AdminService _adminService = AdminService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'لوحة التحكم',
          showBackButton: false,
        ),
      ),
      body: // ... existing dashboard content ...
      bottomNavigationBar: AdminBottomNav(
        currentIndex: 0,
        onTap: (index) => AdminBottomNav.handleNavigation(context, index),
      ),
    );
  }
} 