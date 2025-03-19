import 'package:flutter/material.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';
import '../../components/navigation/nav_bars/admin_nav_bar.dart';
import 'admin_support_page.dart';
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
            Card(
              child: ListTile(
                title: const Text('دعم العملاء'),
                leading: const Icon(Icons.headset_mic_outlined),
                onTap: () {
                  Navigator.pushNamed(context, '/admin/support');
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
      bottomNavigationBar: AdminNavBar(
        currentIndex: 0,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          switch (index) {
            case 4:
              Navigator.pushReplacementNamed(context, '/admin/dashboard');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/admin/applications');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/admin/chat');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/admin/users');
              break;
            case 0:
              // Already on settings page
              break;
          }
        },
      ),
    );
  }
} 