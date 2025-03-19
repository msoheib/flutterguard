import 'package:flutter/material.dart';
import '../widgets/user_route_wrapper.dart';
import '../components/navigation/app_bars/custom_app_bar.dart';
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
    final hasUnread = chat.unreadJobSeeker;
    
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              chat: chat,
              isCompany: false,
            ),
          ),
        ),
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
                      Icons.business,
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
                          chat.companyName ?? 'أسم المتقدم',
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
                          chat.lastMessage ?? 'مرحبا بك',
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
  }
} 