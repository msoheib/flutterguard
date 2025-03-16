import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import 'admin_navbar.dart';
import '../../services/admin_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final AdminService _adminService = AdminService();
  int _selectedNavIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'المحادثات',
          showBackButton: false,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _adminService.getSupportChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data?.docs ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF4CA6A8),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(chat['userName'] ?? 'مستخدم'),
                  subtitle: Text(
                    chat['lastMessage'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: chat['unreadAdmin'] == true
                      ? Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CA6A8),
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/admin/support-chat',
                      arguments: {
                        'chatId': chat['id'],
                        'userId': chat['userId'],
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: AdminNavbar(
        currentIndex: 3, // Support/chat tab
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
              // Already on chat/support page
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