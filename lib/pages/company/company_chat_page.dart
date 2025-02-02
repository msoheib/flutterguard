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
              CustomAppBar(
                title: 'المحادثات',
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

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.separated(
                        itemCount: chats.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final chatDoc = chats[index];
                          Chat? chat;
                          try {
                            chat = Chat.fromFirestore(chatDoc);
                          } catch (e) {
                            print('Error parsing chat: $e');
                            return const SizedBox();
                          }
                          final currentChat = chat;
                          
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentChat.jobSeekerId)
                                .get(),
                            builder: (context, userSnapshot) {
                              if (currentChat.jobSeekerId == null || 
                                  currentChat.jobSeekerId!.isEmpty) {
                                return const SizedBox();
                              }

                              String userName = '';
                              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                                final data = userSnapshot.data!.data() as Map<String, dynamic>?;
                                // First try to get fullName from profile.personalInfo
                                final profile = data?['profile'] as Map<String, dynamic>?;
                                final personalInfo = profile?['personalInfo'] as Map<String, dynamic>?;
                                userName = personalInfo?['fullName'] ?? data?['phoneNumber'] ?? 'مجهول';
                              } else if (userSnapshot.connectionState == ConnectionState.waiting) {
                                userName = 'جاري التحميل...';
                              } else {
                                userName = 'مجهول';
                              }
                              
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetailPage(
                                      chat: currentChat,
                                      isCompany: true,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    image: currentChat.unreadCompany ? const DecorationImage(
                                      image: AssetImage('assets/media/images/stripe_pattern.png'),
                                      repeat: ImageRepeat.repeat,
                                      fit: BoxFit.cover,
                                    ) : null,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        if (currentChat.unreadCompany)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF4CA6A8),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              currentChat.jobSeekerName ?? currentChat.jobSeekerPhone ?? 'مجهول',
                                              style: const TextStyle(
                                                color: Color(0xFF1A1D1E),
                                                fontSize: 14,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              currentChat.lastMessage?.isNotEmpty == true ? currentChat.lastMessage! : 'مرحبا بك',
                                              style: const TextStyle(
                                                color: Color(0xFF6A6A6A),
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFE8ECF4),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Color(0xFF8391A1),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
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
} 