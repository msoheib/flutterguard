import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_list.dart';
import '../../../models/chat.dart';

class ChatListExample extends StatelessWidget {
  const ChatListExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List Example'),
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .where('jobSeekerId', isEqualTo: currentUserId)
              .orderBy('lastMessageTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final chatDocs = snapshot.data?.docs ?? [];
            
            if (chatDocs.isEmpty) {
              return Center(child: Text('No chats found'));
            }
            
            // Convert Firebase documents to ChatListItems
            final chatItems = chatDocs.map((doc) {
              try {
                final chat = Chat.fromFirestore(doc);
                return ChatListItem(
                  name: chat.companyName ?? '',
                  projectName: chat.lastMessage ?? '',
                  hasUnreadMessages: chat.unreadJobSeeker,
                );
              } catch (e) {
                print('Error parsing chat: $e');
                return null;
              }
            }).whereType<ChatListItem>().toList();
            
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ChatList(
                items: chatItems,
                onItemTap: (item) {
                  // Handle tap
                  print('Tapped on ${item.name}');
                },
              ),
            );
          },
        ),
      ),
    );
  }
} 