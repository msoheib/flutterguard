import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/chat_service.dart';
import '../models/chat.dart';
import '../widgets/recyclers/navbar.dart';
import '../widgets/authenticated_layout.dart';
import '../screens/chat_detail_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool isCompany = false; // This should be determined based on user role

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    // For testing purposes, create sample chats
    await _chatService.createSampleChats();
    
    // TODO: Determine if user is company or job seeker
    // This should be fetched from your user profile/auth service
    setState(() {
      isCompany = false; // Default to job seeker for now
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      currentIndex: 3, // Chat page index
      onNavItemTap: (index) {
        // Navigation will be handled by the navbar itself
      },
      child: Container(
        color: const Color(0xFFFBFBFB),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                height: 125,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CA6A8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/media/icons/back.svg',
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        'المحادثات',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 20,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          image: const DecorationImage(
                            image: AssetImage('assets/media/icons/avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Chat List
              Expanded(
                child: StreamBuilder<List<Chat>>(
                  stream: _chatService.getChats(currentUserId, isCompany),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد محادثات',
                          style: TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 16,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      );
                    }

                    final chats = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return _ChatListItem(
                          chat: chat,
                          isCompany: isCompany,
                          onTap: () => _openChatDetail(context, chat),
                        );
                      },
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

  void _openChatDetail(BuildContext context, Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          chat: chat,
          isCompany: isCompany,
        ),
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final Chat chat;
  final bool isCompany;
  final VoidCallback onTap;

  const _ChatListItem({
    required this.chat,
    required this.isCompany,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = isCompany ? chat.unreadCompany : chat.unreadJobSeeker;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF4CA6A8),
                      shape: OvalBorder(),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCompany ? 'الباحث عن عمل' : 'الشركة',
                          style: const TextStyle(
                            color: Color(0xFF1A1D1E),
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnread ? const Color(0xFF4CA6A8) : const Color(0xFF6A6A6A),
                            fontSize: 12,
                            fontFamily: 'Cairo',
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread)
              Container(
                width: 24,
                height: 24,
                decoration: const ShapeDecoration(
                  color: Color(0xFF4CA6A8),
                  shape: OvalBorder(),
                ),
                child: const Center(
                  child: Text(
                    '1',
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