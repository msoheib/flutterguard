import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/validation_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  ChatService();

  // Create or get existing chat
  Future<String> createChat({
    required String jobSeekerId,
    required String companyId,
    required String jobId,
  }) async {
    // Validate input parameters
    if (jobSeekerId.isEmpty || companyId.isEmpty || jobId.isEmpty) {
      throw Exception('Invalid chat parameters');
    }

    final chatData = {
      'jobSeekerId': jobSeekerId,
      'companyId': companyId,
      'jobId': jobId,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'unreadCompany': false,
      'unreadJobSeeker': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Validate chat data before creation
    if (!ValidationService.isValidChat(chatData)) {
      throw Exception('Invalid chat data structure');
    }

    try {
      final chatRef = await _firestore.collection('chats').add(chatData);
      return chatRef.id;
    } catch (e) {
      throw Exception('Failed to create chat: $e');
    }
  }

  // Send message
  Future<void> sendMessage(String chatId, String senderId, String content) async {
    if (chatId.isEmpty || senderId.isEmpty) {
      throw Exception('Invalid chat or sender ID');
    }

    final messageData = {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    };

    if (!ValidationService.isValidMessage(messageData)) {
      throw Exception('Invalid message data structure');
    }

    final batch = _firestore.batch();
    
    try {
      // Add message
      final messageRef = _firestore.collection('messages').doc();
      batch.set(messageRef, messageData);

      // Update chat
      final chatRef = _firestore.collection('chats').doc(chatId);
      batch.update(chatRef, {
        'lastMessage': content,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get chats for user
  Stream<List<Chat>> getChats(String userId, bool isCompany) {
    final field = isCompany ? 'companyId' : 'jobSeekerId';
    return _firestore.collection('chats')
        .where(field, isEqualTo: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList());
  }

  // Get messages for chat
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore.collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  // Mark messages as read
  Future<void> markAsRead(String chatId, String userId, bool isCompany) async {
    final field = isCompany ? 'unreadCompany' : 'unreadJobSeeker';
    await _firestore.collection('chats').doc(chatId).update({
      field: false,
    });

    // Mark all messages from other user as read
    final querySnapshot = await _firestore.collection('messages')
        .where('chatId', isEqualTo: chatId)
        .where('senderId', isNotEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> createSampleChats() async {
    final List<Map<String, dynamic>> sampleChats = [
      {
        'jobSeekerId': 'seeker1',
        'companyId': 'company1',
        'jobId': 'job1',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessage': 'نتطلع للقائك في المقابلة',
        'unreadCompany': false,
        'unreadJobSeeker': true,
      },
      {
        'jobSeekerId': 'seeker1',
        'companyId': 'company2',
        'jobId': 'job2',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessage': 'شكراً لتقديمك على الوظيفة',
        'unreadCompany': true,
        'unreadJobSeeker': true,
      },
      {
        'jobSeekerId': 'seeker1',
        'companyId': 'company3',
        'jobId': 'job3',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessage': 'متى تستطيع بدء العمل؟',
        'unreadCompany': false,
        'unreadJobSeeker': true,
      },
    ];

    // Add chats
    for (var chat in sampleChats) {
      await _firestore.collection('chats').add(chat);
    }

    final List<Map<String, dynamic>> sampleMessages = [
      {
        'chatId': 'chat1',
        'senderId': 'company1',
        'content': 'مرحباً بك، نود مقابلتك للوظيفة',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      },
      {
        'chatId': 'chat1',
        'senderId': 'seeker1',
        'content': 'شكراً لكم، متى موعد المقابلة؟',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': true,
      },
      {
        'chatId': 'chat2',
        'senderId': 'company2',
        'content': 'تم استلام طلبك بنجاح',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      },
    ];

    // Add messages
    for (var message in sampleMessages) {
      await _firestore.collection('messages').add(message);
    }
  }
} 