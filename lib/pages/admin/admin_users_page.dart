import 'package:flutter/material.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';
import '../../components/navigation/app_bars/notification_app_bar.dart';
import '../../components/navigation/nav_bars/admin_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_support_page.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  // Visual index 1 corresponds to Users in the RTL navbar
  int _selectedNavIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const NotificationAppBar(
        title: 'المستخدمين',
        notificationCount: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'jobseeker')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data?.docs ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              
              return Card(
                child: ListTile(
                  title: Text(user['name'] ?? 'مستخدم'),
                  subtitle: Text(user['email'] ?? ''),
                  trailing: Text(
                    user['status'] ?? 'نشط',
                    style: TextStyle(
                      color: user['status'] == 'banned' ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Navigate to user details
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: AdminNavBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          // The AdminNavBar will handle navigation directly
          setState(() {
            _selectedNavIndex = index;
          });
        },
      ),
    );
  }
} 