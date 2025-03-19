import 'package:flutter/material.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';
import '../../components/navigation/app_bars/notification_app_bar.dart';
import '../../components/navigation/nav_bars/admin_nav_bar.dart';
import 'admin_support_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  // Visual index 4 corresponds to Settings in the RTL navbar
  int _selectedNavIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const NotificationAppBar(
        title: 'الإعدادات',
        notificationCount: 0,
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