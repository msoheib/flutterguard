import 'package:flutter/material.dart';
import '../../widgets/company_route_wrapper.dart';
import '../../components/navigation/app_bars/notification_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/chat.dart';
import '../../screens/chat_detail_page.dart';
import '../../components/common/cards/chat_list.dart';

class CompanyChatPage extends StatelessWidget {
  const CompanyChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
    return CompanyRouteWrapper(
      currentIndex: 2,  // Chat tab
      child: Container(
        color: const Color(0xFFFBFBFB),
        child: SafeArea(
          child: Column(
            children: [
              NotificationAppBar(
                title: 'المحادثات',
                notificationCount: 0,
                onNotificationPressed: () {
                  // Navigate to notifications page or show notifications panel
                  // For example:
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
                },
              ),
              
              // Chat List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('companyId', isEqualTo: currentUserId)
                      .orderBy('lastMessageTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
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
                                fontSize: 16,
                                fontFamily: 'Cairo',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: FutureBuilder<List<ChatListItem>>(
                        future: _buildChatItems(chats),
                        builder: (context, chatItemsSnapshot) {
                          if (chatItemsSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                          final chatItems = chatItemsSnapshot.data ?? [];
                          
                          return ChatList(
                            items: chatItems,
                            title: '', // Empty because we use AppBar title
                            onItemTap: (item) {
                              // Find the original chat from the chats list
                              final index = chatItems.indexOf(item);
                              if (index >= 0 && index < chats.length) {
                                final chatDoc = chats[index];
                                try {
                                  final chat = Chat.fromFirestore(chatDoc);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatDetailPage(
                                        chat: chat,
                                        isCompany: true,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error parsing chat: $e');
                                }
                              }
                            },
                          );
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
  
  // Helper method to build ChatListItems from Firestore docs
  Future<List<ChatListItem>> _buildChatItems(List<QueryDocumentSnapshot> chatDocs) async {
    final List<ChatListItem> result = [];
    
    for (final doc in chatDocs) {
      try {
        final chat = Chat.fromFirestore(doc);
        
        if (chat.jobSeekerId == null || chat.jobSeekerId!.isEmpty) {
          continue;
        }
        
        // For the company view, we want to show the job seeker's name
        // First try to use the stored jobSeekerName from the chat document
        String userName = chat.jobSeekerName ?? '';
        String projectInfo = '';
        
        if (userName.isEmpty) {
          // If jobSeekerName is not available in the chat document, fetch from user collection
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(chat.jobSeekerId)
              .get();
              
          if (userDoc.exists) {
            final data = userDoc.data() as Map<String, dynamic>?;
            
            // Try different paths to find the user name
            final profile = data?['profile'] as Map<String, dynamic>?;
            final personalInfo = profile?['personalInfo'] as Map<String, dynamic>?;
            final fullName = personalInfo?['fullName'];
            final name = personalInfo?['name']; 
            final phone = data?['phoneNumber'];
            
            // Use the first available name field or empty string
            userName = fullName ?? name ?? phone ?? '';
          }
        }
        
        // For project info, first try to get relevant job information
        if (chat.jobId.isNotEmpty) {
          try {
            final jobDoc = await FirebaseFirestore.instance
                .collection('jobs')
                .doc(chat.jobId)
                .get();
                
            if (jobDoc.exists) {
              final jobData = jobDoc.data() as Map<String, dynamic>?;
              final title = jobData?['title'];
              final position = jobData?['position'];
              
              projectInfo = title ?? position ?? 'project';
            } else {
              projectInfo = 'project';
            }
          } catch (e) {
            print('Error fetching job info: $e');
            projectInfo = 'project';
          }
        } else {
          // If no job info, use the last message as the project info
          projectInfo = chat.lastMessage?.isNotEmpty == true 
              ? chat.lastMessage! 
              : 'project';
        }
        
        result.add(ChatListItem(
          name: userName,
          projectName: projectInfo,
          hasUnreadMessages: chat.unreadCompany,
        ));
      } catch (e) {
        print('Error creating chat item: $e');
      }
    }
    
    return result;
  }
} 