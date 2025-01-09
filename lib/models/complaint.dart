import 'package:cloud_firestore/cloud_firestore.dart';

enum ComplaintStatus { open, in_progress, resolved, closed }
enum ComplaintPriority { low, medium, high }

class Complaint {
  final String id;
  final String userId;
  final String? companyId;
  final String? jobId;
  final String type;
  final String description;
  final ComplaintStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ComplaintPriority priority;
  final String? assignedTo;

  Complaint({
    required this.id,
    required this.userId,
    this.companyId,
    this.jobId,
    required this.type,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.priority,
    this.assignedTo,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'companyId': companyId,
      'jobId': jobId,
      'type': type,
      'description': description,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'priority': priority.toString().split('.').last,
      'assignedTo': assignedTo,
    };
  }

  static Complaint fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Complaint(
      id: doc.id,
      userId: data['userId'] ?? '',
      companyId: data['companyId'],
      jobId: data['jobId'],
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      status: ComplaintStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => ComplaintStatus.open,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      priority: ComplaintPriority.values.firstWhere(
        (e) => e.toString().split('.').last == data['priority'],
        orElse: () => ComplaintPriority.low,
      ),
      assignedTo: data['assignedTo'],
    );
  }
} 