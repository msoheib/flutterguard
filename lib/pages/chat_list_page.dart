import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';
import '../components/navigation/app_bars/notification_app_bar.dart';
import '../screens/chat_detail_page.dart';
import '../widgets/user_route_wrapper.dart';
import '../components/common/cards/chat_list.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final chatService = ChatService();
    
    return UserRouteWrapper(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: Column(
            children: [
              // Using NotificationAppBar directly 
              const NotificationAppBar(
                title: 'المحادثات',
                notificationCount: 0,
              ),
              
              // Chat list with StreamBuilder
              Expanded(
                child: StreamBuilder<List<Chat>>(
                  stream: chatService.getChats(currentUserId ?? '', false),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final chats = snapshot.data ?? [];

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

                    // Convert Chat objects to ChatListItem objects
                    final chatItems = chats.map((chat) => ChatListItem(
                      name: chat.companyName ?? '',
                      projectName: chat.lastMessage ?? 'Unknown',
                      hasUnreadMessages: chat.unreadJobSeeker,
                    )).toList();

                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: ChatList(
                        items: chatItems,
                        title: '',  // Empty title because we're using the app bar title
                        onItemTap: (item) {
                          // Find the corresponding chat and navigate to chat detail
                          final index = chatItems.indexOf(item);
                          if (index >= 0 && index < chats.length) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailPage(
                                  chat: chats[index],
                                  isCompany: false,
                                ),
                              ),
                            );
                          }
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