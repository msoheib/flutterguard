import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import 'admin_support_page.dart';
import 'admin_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  int _selectedNavIndex = 4; // Settings tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'الإعدادات',
          showBackButton: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('تغيير كلمة المرور'),
                leading: const Icon(Icons.lock_outline),
                onTap: () {
                  // Navigate to change password
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('إعدادات الإشعارات'),
                leading: const Icon(Icons.notifications_outlined),
                onTap: () {
                  // Navigate to notification settings
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('تأكيد تسجيل الخروج'),
                    content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('تسجيل الخروج'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        ),
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
              // Already on settings page
              break;
          }
        },
      ),
    );
  }
} 