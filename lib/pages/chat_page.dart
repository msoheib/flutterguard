import 'package:flutter/material.dart';
import '../widgets/user_route_wrapper.dart';
import '../widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat.dart';
import '../screens/chat_detail_page.dart';
import '../services/admin_service.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  
  const ChatPage({
    required this.chatId,
    super.key,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AdminService _adminService = AdminService();
  String? _assignedAdminId;

  @override
  void initState() {
    super.initState();
    _assignChatToAdmin();
  }

  Future<void> _assignChatToAdmin() async {
    try {
      final admins = await _adminService.getAvailableAdmins();
      if (admins.isNotEmpty) {
        // Assign to the first available admin
        final adminId = admins.first.id;
        await _adminService.assignSupportChat(widget.chatId, adminId);
        setState(() => _assignedAdminId = adminId);
      }
    } catch (e) {
      debugPrint('Error assigning chat to admin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
    return UserRouteWrapper(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              CustomAppBar(
                title: 'المحادثات',
                showBackButton: false,
                showLogo: true,
                showNotification: true,
                onNotificationTap: () {
                  // Handle notification tap
                },
              ),
              
              // Chat List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('participants', arrayContains: currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('حدث خطأ'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final chats = snapshot.data?.docs ?? [];

                    if (chats.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد محادثات',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cairo',
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.separated(
                        itemCount: chats.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final chatDoc = chats[index];
                          final chat = Chat.fromFirestore(chatDoc);
                          
                          return ChatListItem(chat: chat);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Separate widget for chat list item
class ChatListItem extends StatelessWidget {
  final Chat chat;

  const ChatListItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(
            chat: chat,
            isCompany: false,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFE8ECF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.business,
                color: Color(0xFF4CA6A8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.companyName ?? 'مجهول',
                    style: const TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    chat.lastMessage ?? 'مرحبا بك',
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 12,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (chat.unreadJobSeeker)
              Container(
                width: 24,
                height: 24,
                decoration: const ShapeDecoration(
                  color: Color(0xFF4CA6A8),
                  shape: CircleBorder(),
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 