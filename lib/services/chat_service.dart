import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or get existing chat
  Future<String> createChat(String jobSeekerId, String companyId, String jobId) async {
    // Check if chat already exists
    final querySnapshot = await _firestore.collection('chats')
        .where('jobSeekerId', isEqualTo: jobSeekerId)
        .where('companyId', isEqualTo: companyId)
        .where('jobId', isEqualTo: jobId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }

    // Create new chat
    final chatRef = await _firestore.collection('chats').add({
      'jobSeekerId': jobSeekerId,
      'companyId': companyId,
      'jobId': jobId,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'unreadCompany': false,
      'unreadJobSeeker': false,
    });

    return chatRef.id;
  }

  // Send message
  Future<void> sendMessage(String chatId, String senderId, String content) async {
    final batch = _firestore.batch();
    
    // Add message
    final messageRef = _firestore.collection('messages').doc();
    batch.set(messageRef, {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    // Update chat
    final chatRef = _firestore.collection('chats').doc(chatId);
    batch.update(chatRef, {
      'lastMessage': content,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCompany': true,
      'unreadJobSeeker': true,
    });

    await batch.commit();
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