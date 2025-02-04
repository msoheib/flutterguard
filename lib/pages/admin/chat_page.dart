import 'package:flutter/material.dart';
import 'components/admin_bottom_nav.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... existing scaffold content ...
      bottomNavigationBar: AdminBottomNav(
        currentIndex: 2, // Chat is index 2
        onTap: (index) => AdminBottomNav.handleNavigation(context, index),
      ),
    );
  }
} 