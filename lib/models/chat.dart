import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String? jobSeekerId;
  final String? companyId;
  final String jobId;
  final DateTime? lastMessageTime;
  final String? lastMessage;
  final bool unreadCompany;
  final bool unreadJobSeeker;
  final String? jobSeekerName;
  final String? jobSeekerPhone;
  final String? companyName;

  Chat({
    required this.id,
    this.jobSeekerId,
    this.companyId,
    required this.jobId,
    this.lastMessageTime,
    this.lastMessage,
    required this.unreadCompany,
    required this.unreadJobSeeker,
    this.jobSeekerName,
    this.jobSeekerPhone,
    this.companyName,
  });

  Map<String, dynamic> toMap() {
    return {
      'jobSeekerId': jobSeekerId,
      'companyId': companyId,
      'jobId': jobId,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime ?? DateTime.now()),
      'lastMessage': lastMessage,
      'unreadCompany': unreadCompany,
      'unreadJobSeeker': unreadJobSeeker,
      'jobSeekerName': jobSeekerName,
      'jobSeekerPhone': jobSeekerPhone,
      'companyName': companyName,
    };
  }

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return Chat(
      id: doc.id,
      jobSeekerId: data['jobSeekerId'] as String?,
      companyId: data['companyId'] as String?,
      jobId: data['jobId']?.toString() ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
      lastMessage: data['lastMessage'] as String?,
      unreadCompany: data['unreadCompany'] as bool? ?? false,
      unreadJobSeeker: data['unreadJobSeeker'] as bool? ?? false,
      jobSeekerName: data['jobSeekerName'] as String?,
      jobSeekerPhone: data['jobSeekerPhone'] as String?,
      companyName: data['companyName'] as String?,
    );
  }
} 