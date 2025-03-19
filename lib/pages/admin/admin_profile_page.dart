import 'package:flutter/material.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';
import '../../components/navigation/nav_bars/admin_nav_bar.dart';
import '../../services/admin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_support_page.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final AdminService _adminService = AdminService();
  int _selectedNavIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'الملف الشخصي',
          showBackButton: false,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admins')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final adminData = snapshot.data?.data() as Map<String, dynamic>?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF4CA6A8),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    adminData?['name'] ?? 'مشرف',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    adminData?['email'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'الصلاحيات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildPermissionsList(adminData?['permissions'] ?? []),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AdminNavBar(
        currentIndex: 4, // Profile/settings tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/admin/dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/admin/users');
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
              // Already on profile/settings page
              break;
          }
        },
      ),
    );
  }

  List<Widget> _buildPermissionsList(List<dynamic> permissions) {
    final Map<String, String> permissionLabels = {
      'manage_users': 'إدارة المستخدمين',
      'manage_companies': 'إدارة الشركات',
      'manage_jobs': 'إدارة الوظائف',
      'manage_support': 'إدارة الدعم الفني',
      'ban_users': 'حظر المستخدمين',
      'delete_accounts': 'حذف الحسابات',
      'edit_profiles': 'تعديل الملفات الشخصية',
      'manage_blacklist': 'إدارة القائمة السوداء',
      'view_analytics': 'عرض التحليلات',
      'manage_admins': 'إدارة المشرفين',
    };

    return permissions.map((permission) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF4CA6A8)),
            const SizedBox(width: 8),
            Text(
              permissionLabels[permission] ?? permission,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
} 