import 'package:flutter/material.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';
import '../../components/navigation/app_bars/notification_app_bar.dart';
import '../../components/navigation/nav_bars/admin_nav_bar.dart';
import '../../services/admin_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final AdminService _adminService = AdminService();
  // Visual index 3 corresponds to Support/Chat in the RTL navbar
  int _selectedNavIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const NotificationAppBar(
        title: 'الدعم الفني',
        notificationCount: 0,
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
          
          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد محادثات',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 319,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: chats.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final chat = chats[index].data() as Map<String, dynamic>;
                        final hasUnread = chat['unreadAdmin'] == true;
                        
                        return Container(
                          width: double.infinity,
                          child: GestureDetector(
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // User info section (left side)
                                Container(
                                  width: 172,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Avatar
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: ShapeDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          shape: const OvalBorder(),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Color(0xFF4CA6A8),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Name and message
                                      Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              chat['userName'] ?? 'أسم المتقدم',
                                              style: const TextStyle(
                                                color: Color(0xFF1A1D1E),
                                                fontSize: 14,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w400,
                                                height: 1.71,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              chat['lastMessage'] ?? 'مرحبا بك',
                                              style: const TextStyle(
                                                color: Color(0xFF6A6A6A),
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w500,
                                                height: 1.67,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Notification circle
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFF4CA6A8),
                                    shape: OvalBorder(),
                                  ),
                                ),
                                
                                // Notification count
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Center(
                                    child: Text(
                                      '2',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
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