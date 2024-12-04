import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  final String id;
  final String jobId;
  final String jobSeekerId;
  final String jobSeekerName;
  final String jobTitle;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime appliedAt;
  final bool isRead;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.jobSeekerId,
    required this.jobSeekerName,
    required this.jobTitle,
    required this.status,
    required this.appliedAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'jobSeekerId': jobSeekerId,
      'jobSeekerName': jobSeekerName,
      'jobTitle': jobTitle,
      'status': status,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'isRead': isRead,
    };
  }

  static JobApplication fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobApplication(
      id: doc.id,
      jobId: data['jobId'] ?? '',
      jobSeekerId: data['jobSeekerId'] ?? '',
      jobSeekerName: data['jobSeekerName'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      status: data['status'] ?? 'pending',
      appliedAt: (data['appliedAt'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }
} 