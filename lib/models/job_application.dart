import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  final String id;
  final String userId;
  final String status;
  final DateTime appliedAt;
  final DateTime? reviewedAt;
  final String? coverLetter;
  final List<String>? attachments;
  final String? jobId;
  final String? jobTitle;
  final String? companyId;
  final String? companyName;

  static const String STATUS_PENDING = 'pending';
  static const String STATUS_REVIEWED = 'reviewed';
  static const String STATUS_ACCEPTED = 'accepted';
  static const String STATUS_REJECTED = 'rejected';

  JobApplication({
    required this.id,
    required this.userId,
    this.status = STATUS_PENDING,
    required this.appliedAt,
    this.reviewedAt,
    this.coverLetter,
    this.attachments,
    this.jobId,
    this.jobTitle,
    this.companyId,
    this.companyName,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'status': status,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      'coverLetter': coverLetter,
      'attachments': attachments,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'companyId': companyId,
      'companyName': companyName,
    };
  }

  static JobApplication fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobApplication(
      id: doc.id,
      userId: data['userId'] ?? '',
      status: data['status'] ?? STATUS_PENDING,
      appliedAt: (data['appliedAt'] as Timestamp).toDate(),
      reviewedAt: data['reviewedAt'] != null ? (data['reviewedAt'] as Timestamp).toDate() : null,
      coverLetter: data['coverLetter'],
      attachments: data['attachments'] != null ? List<String>.from(data['attachments']) : null,
      jobId: data['jobId'],
      jobTitle: data['jobTitle'],
      companyId: data['companyId'],
      companyName: data['companyName'],
    );
  }
} 