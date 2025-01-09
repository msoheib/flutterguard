import 'package:cloud_firestore/cloud_firestore.dart';

class Application {
  final String id;
  final String jobId;
  final String jobseekerId;
  final String companyId;
  final String status;
  final DateTime appliedAt;
  final DateTime updatedAt;
  final String? coverLetter;
  final List<String>? attachments;

  Application({
    required this.id,
    required this.jobId,
    required this.jobseekerId,
    required this.companyId,
    required this.status,
    required this.appliedAt,
    required this.updatedAt,
    this.coverLetter,
    this.attachments,
  });

  factory Application.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Application(
      id: doc.id,
      jobId: data['jobId'],
      jobseekerId: data['jobseekerId'],
      companyId: data['companyId'],
      status: data['status'],
      appliedAt: (data['appliedAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      coverLetter: data['coverLetter'],
      attachments: data['attachments'] != null ? List<String>.from(data['attachments']) : null,
    );
  }
} 