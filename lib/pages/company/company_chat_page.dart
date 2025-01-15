import 'package:flutter/material.dart';
import '../../widgets/company_route_wrapper.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/chat.dart';
import '../../screens/chat_detail_page.dart';

class CompanyChatPage extends StatelessWidget {
  const CompanyChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
    return CompanyRouteWrapper(
      currentIndex: 1,  // Messages tab
      child: Container(
        color: const Color(0xFFFBFBFB),
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: 'المحادثات'),
              
              // Chat List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('companyId', isEqualTo: currentUserId)
                      .where('lastMessage', isNotEqualTo: '')
                      .orderBy('lastMessage')
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

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chatDoc = chats[index];
                        final chat = Chat.fromFirestore(chatDoc);
                        
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(chat.jobSeekerId)
                              .get(),
                          builder: (context, userSnapshot) {
                            String userName = 'مجهول';
                            if (userSnapshot.hasData && userSnapshot.data!.exists) {
                              final data = userSnapshot.data!.data() as Map<String, dynamic>?;
                              userName = data?['name'] ?? 'مجهول';
                            }
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Color(0xFF1A1D1E),
                                    fontSize: 16,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: chat.lastMessage.isNotEmpty
                                    ? Text(
                                        chat.lastMessage,
                                        style: const TextStyle(
                                          color: Color(0xFF6A6A6A),
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                                trailing: chat.unreadCompany
                                    ? Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF4CA6A8),
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : null,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatDetailPage(
                                        chat: chat,
                                        isCompany: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
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
} 