import 'package:cloud_firestore/cloud_firestore.dart';

class JobPost {
  final String id;
  final String title;
  final String companyId;
  final String companyName;
  final Map<String, dynamic> location;
  final Map<String, dynamic> salary;
  final String type;
  final String workType;
  final String description;
  final List<String> requiredSkills;
  final String status;
  final int totalApplications;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? employmentType;

  String get company => companyName;

  JobPost({
    required this.id,
    required this.title,
    required this.companyId,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.type,
    required this.workType,
    required this.description,
    required this.requiredSkills,
    required this.status,
    required this.totalApplications,
    required this.createdAt,
    this.updatedAt,
    this.employmentType,
  });

  factory JobPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Handle location that might be string or map
    Map<String, dynamic> locationMap;
    if (data['location'] is String) {
      locationMap = {
        'city': data['location'],
        'address': data['location']
      };
    } else {
      locationMap = Map<String, dynamic>.from(data['location'] ?? {});
    }

    // Handle salary that might be number or map
    Map<String, dynamic> salaryMap;
    if (data['salary'] is num) {
      salaryMap = {
        'amount': data['salary'],
        'currency': 'SAR'
      };
    } else {
      salaryMap = Map<String, dynamic>.from(data['salary'] ?? {});
    }

    return JobPost(
      id: doc.id,
      title: data['title'] ?? '',
      companyId: data['companyId'] ?? '',
      companyName: data['companyName'] ?? '',
      location: locationMap,
      salary: salaryMap,
      type: data['type'] ?? '',
      workType: data['workType'] ?? '',
      description: data['description'] ?? '',
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      status: data['status'] ?? 'inactive',
      totalApplications: data['totalApplications'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
      employmentType: data['employmentType'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'companyId': companyId,
      'companyName': companyName,
      'location': location,
      'salary': salary,
      'type': type,
      'workType': workType,
      'description': description,
      'requiredSkills': requiredSkills,
      'status': status,
      'totalApplications': totalApplications,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'employmentType': employmentType,
    };
  }

  // Alias for toFirestore() for backward compatibility
  Map<String, dynamic> toMap() => toFirestore();
}
