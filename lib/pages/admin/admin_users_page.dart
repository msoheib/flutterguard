import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_support_page.dart';
import 'admin_navbar.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  int _selectedNavIndex = 1; // Users tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'المستخدمين',
          showBackButton: false,
        ),
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
      bottomNavigationBar: AdminNavbar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/admin/dashboard');
              break;
            case 1:
              // Already on users page
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/admin/applications');
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminSupportPage()),
              );
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/admin/settings');
              break;
          }
        },
      ),
    );
  }
} 