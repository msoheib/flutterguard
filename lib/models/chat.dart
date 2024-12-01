import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String jobSeekerId;
  final String companyId;
  final String jobId;
  final DateTime lastMessageTime;
  final String lastMessage;
  final bool unreadCompany;
  final bool unreadJobSeeker;

  Chat({
    required this.id,
    required this.jobSeekerId,
    required this.companyId,
    required this.jobId,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.unreadCompany,
    required this.unreadJobSeeker,
  });

  Map<String, dynamic> toMap() {
    return {
      'jobSeekerId': jobSeekerId,
      'companyId': companyId,
      'jobId': jobId,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessage': lastMessage,
      'unreadCompany': unreadCompany,
      'unreadJobSeeker': unreadJobSeeker,
    };
  }

  static Chat fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      jobSeekerId: data['jobSeekerId'],
      companyId: data['companyId'],
      jobId: data['jobId'],
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'],
      unreadCompany: data['unreadCompany'],
      unreadJobSeeker: data['unreadJobSeeker'],
    );
  }
} 